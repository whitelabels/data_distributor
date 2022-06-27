Gem::Specification.new do |s|
  s.name = "data_distributor"
  s.version = "0.1.0"
  s.summary = "Bygnings- og boligregistret"
  s.description = "Lookup in Danish register of Buildings and Housing"
  s.authors = "[Whitelabels.dk]"
  s.email = "mail@whitelabels.dk"
  s.license = ""
  s.files = Dir["lib/**/*.rb"]

  s.add_runtime_dependency "faraday", "= 0.15.4"
  s.add_runtime_dependency "json"

  s.add_development_dependency "minitest"
  s.add_development_dependency "rake"
  s.add_development_dependency "timecop"
  s.add_development_dependency "vcr"
  s.add_development_dependency "webmock"
end