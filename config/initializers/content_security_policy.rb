# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self, :https
    policy.font_src :self, :https, :data
    policy.img_src :self, :https, :data
    policy.object_src :none
    policy.script_src :self, :https
    policy.style_src :self, :unsafe_inline, :https
    # Specify URI for violation reports
    policy.report_uri -> do
                        "https://api.honeybadger.io/v1/browser/csp?api_key=#{ENV["HONEYBADGER_API_KEY"]}&report_only=true&env=#{Rails.env}&context[user_id]=#{respond_to?(:current_user) ? current_user&.id : nil}"
                      end
  end

  # Generate session nonces for permitted importmap, inline scripts, and inline styles.
  # config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
  config.content_security_policy_nonce_generator = ->(request) do
    request.session[:csp_nonce] ||= SecureRandom.base64(16)
  end
  config.content_security_policy_nonce_directives = %w[script-src]

  # Report violations without enforcing the policy.
  config.content_security_policy_report_only = true if Rails.env.development?
end
