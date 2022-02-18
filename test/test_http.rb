# frozen_string_literal: true
require "graphql"
require "graphql/client/http"
require "minitest/autorun"

class TestHTTP < MiniTest::Test
  SWAPI = GraphQL::Client::HTTP.new("https://swapi-graphql.netlify.app/.netlify/functions/index") do
    def headers(_context)
      { "User-Agent" => "GraphQL/1.0" }
    end
  end

  def test_execute
    skip "TestHTTP disabled by default" unless __FILE__ == $PROGRAM_NAME

    document = GraphQL.parse(<<-'GRAPHQL')
      query getPerson($personID: ID!) {
        person(personID: $personID) {
          name
        }
      }
    GRAPHQL

    name = "getPerson"
    variables = { "personID" => 4 }

    expected = {
      "data" => {
        "person" => {
          "name" => "Darth Vader"
        }
      }
    }
    actual = SWAPI.execute(document: document, operation_name: name, variables: variables)
    assert_equal(expected, actual)
  end
end
