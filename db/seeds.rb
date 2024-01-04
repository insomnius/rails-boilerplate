# frozen_string_literal: true

if Rails.env.development?
  Doorkeeper::Application.create(
    name:         'rails boilerplate application',
    uid:          'c89c1f81-0312-4ea3-852b-7dbf657db54b',
    secret:       'themostsecrettoken',
    redirect_uri: 'http://localhost:3000',
    scopes:       'read write update',
    confidential: true
  )
end
