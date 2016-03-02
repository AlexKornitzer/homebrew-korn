class Metasploit < Formula
  desc "The Metasploit Framework"
  homepage 'http://www.metasploit.com/framework/'
  head "https://github.com/rapid7/metasploit-framework.git"

  stable do
    url "http://downloads.metasploit.com/data/releases/archive/framework-4.11.3-2015070901.tar.bz2"
    sha1 'd9ce2ed088967a4b5e1f957aa09cc70cf60bf01a'
  end

  # Resources


  # Add the depends on
  # NOTE: Cant use the system ruby as then we cant install gems!
  depends_on "libxml2"
  depends_on "postgresql"
  depends_on "ruby"

  def install
    # NOTE: Maybe we should use brew gem and manually list all the gems we need?
    # Install the bundle gem if it is not installed
#    if which("bundle").to_s != "#{HOMEBREW_PREFIX}/bin/bundle"
      system "gem", "install", "bundler"
#    end

    # Lazily get bundle to install the gems using bundle
    system "#{HOMEBREW_PREFIX}/bin/bundle", "install"

    # Install the metasploit framework
    libexec.install Dir["*"]
    bin.mkpath
    Dir["#{libexec}/msf*"].each {|f| ln_s f, bin}
  end

  def caveats;<<-EOS.undent
    This installation does not create the metasploit database, this must be done manually.
      1. Initialise the database:
        initdb /usr/local/var/postgres

      2. (Optional) To have launchd start postgresql at login:
        ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
      Then to load postgresql now:
        launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
      Or, if you don't want/need launchctl, you can just run:
        postgres -D /usr/local/var/postgres

      3. Create the user and database for the metasploit framework
        createuser msf -P -h localhost
        createdb -O msf msf -h localhost

      4. Create a file '' with the following:
        # Development Database
        development: &pgsql
          adapter: postgresql
          database: msf
          username: msf
          password: YOUR_PASSWORD_FOR_PGSQL
          host: localhost
          port: 5432
          pool: 5
          timeout: 5

        # Production database -- same as dev
        production: &production
          <<: *pgsql
    EOS
  end
end
