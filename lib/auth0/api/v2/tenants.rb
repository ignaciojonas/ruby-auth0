module Auth0
  module Api
    module V2
      # https://auth0.com/docs/api/v2#!/Tenants
      module Tenants
        attr_reader :tenant_path

        # https://auth0.com/docs/api/v2#!/Tenants/get_settings
        def get_tenant_settings(fields: nil, include_fields: true)
          request_params = {
            fields: fields,
            include_fields: include_fields
          }
          get(tenant_path, request_params)
        end

        # https://auth0.com/docs/api/v2#!/Tenants/patch_settings
        def update_tenant_settings(body)
          fail Auth0::InvalidParameter, 'Must supply a valid body to update tenant settings' if body.to_s.empty?
          patch(tenant_path, body)
        end

        def tenant_path
          @tenant_path ||= '/api/v2/tenants/settings'
        end
      end
    end
  end
end