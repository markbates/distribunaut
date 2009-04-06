# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{distribunaut}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["markbates"]
  s.date = %q{2009-04-05}
  s.default_executable = %q{distribunaut_ring_server}
  s.description = %q{distribunaut was developed by: markbates}
  s.email = %q{}
  s.executables = ["distribunaut_ring_server"]
  s.extra_rdoc_files = ["README"]
  s.files = ["lib/distribunaut/distributable.rb", "lib/distribunaut/distributed.rb", "lib/distribunaut/errors/errors.rb", "lib/distribunaut/tasks/ring_server_tasks.rake", "lib/distribunaut/utils/rinda.rb", "lib/distribunaut.rb", "lib/distribunaut_tasks.rb", "README", "bin/distribunaut_ring_server"]
  s.has_rdoc = true
  s.homepage = %q{}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{distribunaut}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{distribunaut}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<configatron>, [">= 0"])
      s.add_runtime_dependency(%q<cachetastic>, [">= 0"])
      s.add_runtime_dependency(%q<addressable>, [">= 0"])
      s.add_runtime_dependency(%q<daemons>, [">= 0"])
    else
      s.add_dependency(%q<configatron>, [">= 0"])
      s.add_dependency(%q<cachetastic>, [">= 0"])
      s.add_dependency(%q<addressable>, [">= 0"])
      s.add_dependency(%q<daemons>, [">= 0"])
    end
  else
    s.add_dependency(%q<configatron>, [">= 0"])
    s.add_dependency(%q<cachetastic>, [">= 0"])
    s.add_dependency(%q<addressable>, [">= 0"])
    s.add_dependency(%q<daemons>, [">= 0"])
  end
end
