require 'securerandom'

module LjaxRails
  module LjaxRenderer
    def render_partial(context, options, &block)
      if options.dig(:locals) && options.dig(:locals, :remote) && options.dig(:locals, :remote_url)
        partial = options.delete :partial
        encrypted_partial = LjaxRails.encryptor.encrypt_and_sign partial

        url = options[:locals].delete :remote_url
        id = "ljax-#{SecureRandom.uuid}"
        loading = options[:locals].delete :loading
        js_success_callback = options[:locals].delete :js_success_callback

        %Q!<div id="#{id}" class="ljax-container" data-ljax-partial="#{encrypted_partial}"#{%Q( data-remote-url="#{url}") if url} data-js-success-callback="#{js_success_callback}">#{loading}</div>!.html_safe
      else
        super
      end
    end
  end
end

ActionView::Renderer.send :prepend, LjaxRails::LjaxRenderer
