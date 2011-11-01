# A sample Guardfile
# More info at https://github.com/guard/guard#readme

# Generating JavaScript files with no file-specific namespaces. Conflicts may
# occur. TODO: fix.
guard 'coffeescript', :input => 'src', :output => 'build', :bare => true

guard 'jessie' do
  watch(%r{^spec/.+(_spec|Spec)\.(js|coffee)$})
  watch(%r{^src/(.+)\.coffee$}) { |m| "spec/#{m[1]}_spec.coffee" }
  watch('spec/spec_helper.js') { "spec" }
end

