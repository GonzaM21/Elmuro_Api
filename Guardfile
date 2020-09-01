# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :rspec, cli: '--color --fail-fast -d' do
  # Model sources
  watch(%r{^models/(.+)\.rb$}) { |m| "spec/models/#{m[1]}_spec.rb" }

  # Controllers
  watch(%r{^(src/controllers)/(.+)\.rb$}) { |m| "spec/#{m[1]}/#{m[2]}_controller_spec.rb" }

  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb') { 'spec' }

  # Rails example
  watch(%r{^src/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^src/(.*)(\.erb|\.haml)$}) { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^src/controllers/(.+)_(controller)\.rb$}) do |m|
    [
      "spec/routing/#{m[1]}_routing_spec.rb",
      "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb",
      "spec/acceptance/#{m[1]}_spec.rb"
    ]
  end
  watch(%r{^spec/support/(.+)\.rb$}) { 'spec' }
  watch('config/routes.rb') { 'spec/routing' }
  watch('src/controllers/application_controller.rb') { 'spec/controllers' }

  # Turnip features and steps
  watch(%r{^spec/acceptance/(.+)\.feature$})
  watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$}) do |m|
    Dir[File.join("**/#{m[1]}.feature")][0] || 'spec/acceptance'
  end
end
