module Auth0
  module Api
    module V2
      # Methods to use the rules endpoints
      module ResourceServers
        attr_reader :resource_servers_path

        # Retrieves a resource server by its ID.
        # @see https://auth0.com/docs/api/management/v2#!/Resource_Servers/get_resource_servers_by_id
        # @param resource_server_id [string]   The id of the resource server to retrieve
        #
        # @return [json] Returns the resource server.
        def resource_server(resource_server_id)
          fail Auth0::InvalidParameter, 'Must supply a valid resource server id' if resource_server_id.to_s.empty?
          path = "#{resource_servers_path}/#{resource_server_id}"
          get(path)
        end

        alias_method :get_resource_server, :resource_server

        # Creates a new resource server according to the JSON object received in body.
        # @see https://auth0.com/docs/api/management/v2#!/Resource_Servers/post_resource_servers
        # @param identifier [string] The identifier of the resource server.
        # @param name [string]   The name of the resource server. Must contain at least one character.
        # Does not allow '<' or '>'.
        # @param signing_alg [string] The algorithm used to sign tokens.
        # @param signing_secret [string] The secret used to sign tokens when using symmetric algorithms
        # @param token_lifetime [integer] The amount of time (in seconds) that the token will be valid after being issued
        # @param scope [array] The scope of the resource server.
        #
        # @return [json] Returns the resource server.
        def create_resource_server(identifier, name=nil, signing_alg = nil, signing_secret=nil, token_lifetime=nil, scope=nil)
          fail Auth0::InvalidParameter, 'Must supply a valid name' if name.to_s.empty?
          fail Auth0::InvalidParameter, 'Must supply a valid identifier' if identifier.to_s.empty?
          request_params = {
            name: name,
            identifier: identifier,
            signing_alg: signing_alg,
            signing_secret: signing_secret,
            token_lifetime: token_lifetime,
            scope: scope,
          }
          post(resource_servers_path, request_params)
        end

        # Deletes a rule.
        # @see https://auth0.com/docs/api/v2#!/Rules/delete_rules_by_id
        # @param rule_id [string] The id of the rule to retrieve
        def delete_resource_server(resource_server_id)
          fail Auth0::InvalidParameter, 'Must supply a valid resource server id' if resource_server_id.to_s.empty?
          path = "#{resource_servers_path}/#{resource_server_id}"
          delete(path)
        end

        private

        # Resource Servers API path
        def resource_servers_path
          @rules_path ||= '/api/v2/resource_servers'
        end
      end
    end
  end
end
