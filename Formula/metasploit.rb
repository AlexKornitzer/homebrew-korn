class Metasploit < Formula
  desc "The Metasploit Framework"
  homepage 'http://www.metasploit.com/framework/'
  head "https://github.com/rapid7/metasploit-framework.git"

  stable do
    url "http://downloads.metasploit.com/data/releases/archive/framework-4.11.3-2015070901.tar.bz2"
    sha1 'd9ce2ed088967a4b5e1f957aa09cc70cf60bf01a'
  end

  # Add the depends on
  depends_on "libxml2"
  depends_on "postgresql"
  # NOTE: Cant use the system ruby as then we need sudo to install gems!
  depends_on "ruby" if !which("bundle")

  def install
    # Get the path to bundle, install if required
    bundler_path = which("bundle").to_s
    if !which("bundle")
      bundler_path = "#{HOMEBREW_PREFIX}/bin/bundle"
      if !File.exist?(bundler_path)
        system "gem", "install", "bundler"
      end
    end

    # Install the metasploit framework
    libexec.install Dir["*"]
    bin.mkpath
    Dir["#{libexec}/msf*"].each {|f| ln_s f, bin}

    # Install all required gems into the libexec of the Keg
    (libexec).cd { system "#{bundler_path}", "install", "--path", "vendor/bundle" }
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
