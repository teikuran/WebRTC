Feature: CAMARA WebRTC Events, v0.1.0 - Operation deleteSubscription

  Background: Common deleteSubscription setup
    Given an environment at "apiRoot"
    And the resource "/webrtc-call-handling/v0.1/subscriptions/{subscriptionId}"                                                              |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" is set to a UUID value
    And the path parameter "subscriptionId" is set by default to a existing register session
    # Properties not explicitly overwitten in the Scenarios can take any values compliant with the schema

  @webrtc_events_deleteSubscription_01_generic_success_scenario
  Scenario: Retrieve a webrtc-events event subscription
    Given an existing events subscription with "subscriptionId" as "qs15-h556-rt89-1298"
    And the path parameter "subscriptionId" is set to the value for that subscription
    When the client sends a DELETE request to "/subscriptions/qs15-h556-rt89-1298"
    Then the response status code should be 202 or 204
    And the response header "x-correlator" has same value as the request header "x-correlator"

  # Error scenarios

  @webrtc_events_deleteSubscription_404_subscription_not_found
  Scenario: Identifier cannot be matched to a subscription
    Given the path parameter "subscriptionId" is compliant with the parameter schema but does not identify a valid session
    When the HTTP "DELETE" request is sent
    Then the response status code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  # Generic 400 errors

  @webrtc_events_deleteSubscription_400.1_no_request
  Scenario: Missing request path parameter
    Given the path parameter "subscriptionId" is not included
    When the HTTP "DELETE" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_deleteSubscription_400.2_empty_request
  Scenario: Empty object as request path parameter
    Given the path parameter "subscriptionId" is set to ""
    When the HTTP "DELETE" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  # Generic 401 errors

  @webrtc_events_deleteSubscription_401.1_no_authorization_header
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    And the path parameter "subscriptionId" is valid
    When the HTTP "DELETE" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_deleteSubscription_401.2_expired_access_token
  Scenario: Expired access token
    Given the header "Authorization" is set to an expired access token
    And the path parameter "subscriptionId" is valid
    When the HTTP "DELETE" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_deleteSubscription_401.3_invalid_access_token
  Scenario: Invalid access token
    Given the header "Authorization" is set to an invalid access token
    And the path parameter "subscriptionId" is valid
    When the HTTP "DELETE" request is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text