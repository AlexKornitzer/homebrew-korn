class Metasploit < Formula
  desc "The Metasploit Framework"
  homepage 'http://www.metasploit.com/framework/'
  head "https://github.com/rapid7/metasploit-framework.git"

  stable do
    url "http://downloads.metasploit.com/data/releases/framework-4.11.4-2015102801.tar.bz2"
    sha1 'b12991d879d7eb664ffd8f72e4fa11611f10a07d'
  end

  # Resources


  # Add the depends on


  def install
    libexec.install Dir["msf*",
                        'config',
                        'data',
                        'db',
                        'documentation',
                        'external',
                        'features',
                        'lib',
                        'modules',
                        'plugins',
                        'script',
                        'scripts',
                        'spec',
                        'test',
                        'tools']
    bin.mkpath
    Dir["#{libexec}/msf*"].each {|f| ln_s f, bin}
  end

  def caveats; <<-EOS.undent
    Metasploit can be updated in-place by doing:
      cd `brew --prefix metasploit`/libexec/
      svn up
    EOS
  end
end
