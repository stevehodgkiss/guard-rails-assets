require 'rake/dsl_definition'
module Guard

  class RailsAssets::RailsRunner

    def initialize(options)
      @sprockets_environment = options[:sprockets_environment] || lambda { Rails.application.config.assets }
      @environment_path = options[:environment_path] || "config/environment.rb"
      @precompile = options[:precompile]
    end

    # Methods to run the asset pipeline
    # Taken from - https://github.com/rails/rails/blob/master/actionpack/lib/sprockets/assets.rake
    class AssetPipeline
      include Rake::DSL
      
      def initialize(sprockets_environment, precompile)
        @env = sprockets_environment
        @precompile = precompile
      end
      
      def clean
        path = if defined?(Rails)
          Rails.public_path + @env.prefix
        else
          @env.static_root
        end
        rm_rf path, :secure => true
      end

      def precompile
        assets = @precompile
        if defined?(Rails)
          Sprockets::Helpers::RailsHelper
          Rails.application.config.action_controller.perform_caching = true
          assets ||= Rails.application.config.assets.precompile
        end
        @env.precompile(*assets)
      end
    end

    def boot_rails
      @rails_booted ||= begin
        require "#{Dir.pwd}/#{@environment_path}"
        true
      end
    end
    
    def asset_pipeline
      @asset_pipeline ||= AssetPipeline.new(@sprockets_environment.call, @precompile)
    end

    def run_compiler
      begin
        @failed = false
        asset_pipeline.clean
        asset_pipeline.precompile
      rescue => e
        puts "An error occurred compiling assets: #{e}"
        @failed = true
      end
    end

    # Runs the asset pipeline compiler.
    #
    # @return [ Boolean ] Whether the compilation was successful or not
    def compile_assets
      boot_rails
      run_compiler
      
      !failed?
    end

    def failed?
      @failed
    end
  end
end
