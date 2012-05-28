require 'rubygems'
require 'rspec/core'

def run(sourceDir, requiredMod, reportFile)
  $:.unshift(sourceDir) unless $:.include?(sourceDir)

	RSpec::Core::Runner.module_eval """
	 	def self.autorun_with_args(args)
			return if autorun_disabled? || installed_at_exit? || running_in_drb?
			@installed_at_exit = true 
			run(args, $stderr, $stdout)
		end"""

	opts = [sourceDir, '-c', '-f', 'documentation']

	if requiredMod
		opts = ['-r'].product(requiredMod.split(',')).flatten + opts
	end

	failures = RSpec::Core::Runner.autorun_with_args(opts)
	failures == 0
end
