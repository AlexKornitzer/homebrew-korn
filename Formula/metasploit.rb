class Metasploit < Formula
  desc "The Metasploit Framework"
  homepage 'http://www.metasploit.com/framework/'
  head "https://github.com/rapid7/metasploit-framework.git"

  stable do
    url "http://updates.metasploit.com/data/releases/framework-3.7.2.tar.bz2"
    sha1 'b12991d879d7eb664ffd8f72e4fa11611f10a07d'
  end

  # Add the depends on
  def install
    libexec.install Dir["msf*",'data','external','lib','modules','plugins','scripts','test','tools']
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
