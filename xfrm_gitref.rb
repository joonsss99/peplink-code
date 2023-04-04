#!/usr/bin/env ruby

def git_ls_remote(url, project, ref)
  # using puts (also print) will slow down multi-thread execution of git command
  # unless "puts "thread join" is also added in the main thread
  #puts "git ls-remote --exit-code #{url}/#{project} #{ref}"
  git_output = `git -c protocol.version=0 ls-remote --exit-code #{url}/#{project} #{ref}`
  if $?.exitstatus == 0
    git_output
  else
    ""
  end
end

def refs_pick_output(output)
  out = []
  lines = output.split("\n")
  # the pattern in order of precedence
  patterns = [ /refs\/heads\//, /refs\/tags\/.*\^\{\}$/, /refs\/tags\// ]
  # first pattern matching 'lines' goes to 'out'
  patterns.find do |f|
    out = lines.grep(f)
    out[0]
  end

  return "" unless out[0]

  out[0].scan(/\w+/)[0]
end

def git_ref2sha(url, project, ref)
  if ref =~ /^refs\//
    output = git_ls_remote(url, project, ref)
    hash = output.scan(/\w+/)[0]
  else
    newref = "refs/tags/#{ref} refs/tags/#{ref}^{} refs/heads/#{ref}"
    output = git_ls_remote(url, project, newref)
    hash = refs_pick_output(output)
  end
  return hash, output
end

def git_ref2sha_retry(url, project, ref, max_retry)
  # try a few times in case server has connectivity problem
  err_retry = 0
  while err_retry < max_retry
    sha1, lsremote = git_ref2sha(url, project, ref)
    if sha1.length > 0
      return sha1, lsremote
    end
    err_retry = err_retry + 1
    puts "retrying git ls-remote x#{err_retry}"
    sleep 0.3
  end
  return "", ""
end

# [ { key, type, project, refs, sha1, output } ]
# e.g  { "speedfusion_GIT", :git, "pepos/speedfusion", "master", "1234aeafe...", output=>"..." }
# e.g  { "openssh-legacy_REV", :svn, output => "value..." }
def pkgversion_parse(l)
  h = {}

  h[:input] = l

  if l !~ /_GIT=/
    h[:type] = :not_git
    h[:output] = l
    return h
  end

  equal = (l =~ /=/)
  key = l[0 .. equal - 1]
  val = l[equal + 1 .. l.length]

  at = (val =~ /@/)
  proj = val[0 .. at - 1]
  refs = val[at + 1 .. val.length].chomp

  h[:type] = :git
  h[:key] = key
  h[:project] = proj
  h[:refs] = refs

  h
end

def transform_git_ref(url, file, out)
  pkg = []

  open(file, 'r') do |f|
    f.each do |l|
      pkg.push pkgversion_parse(l)
    end
  end

  max_thread = 30
  th_pool = []

  pkg.each do |p|
    next if p[:type] != :git

    while th_pool.length >= max_thread
      th_pool.select! do |th|
        if th.status == false
          #puts "thread join"
          th.join
          false
        else
          true
        end
      end
    end

    th_pool << Thread.new(p) do |p|
      sha1, lsremote = git_ref2sha_retry(url, p[:project], p[:refs], 5)
      if sha1.length > 0
        p[:output] = "#{p[:key]}=#{p[:project]}@#{sha1}"
        p[:lsremote] = lsremote
      else
        p[:output] = ""
      end
    end
  end

  th_pool.each do |th|
    th.join
  end

  #puts pkg
  open(out, 'w') do |of|
    pkg.each do |p|
      of.puts p[:output]
    end
  end
  #open("xfrm_gitref.debug.log", 'w') do |of|
  #  pkg.each do |p|
  #    of.puts "#{p[:project]}@#{p[:refs]}:\n#{p[:lsremote]}"
  #  end
  #end
  return 0
end

begin
  url = ENV["GIT_FETCH_URL"] || "ssh://gerrit.peplink.com:29418"
  #puts ARGV[0]
  #puts ARGV[1]
  val = transform_git_ref(url, ARGV[0], ARGV[1])
  exit val
end
