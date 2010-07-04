Feature: Welcoming new developers
  As a software developer
  I want the world to be welcomed
  So I get a fuzzy feeling of success

  Scenario: Loading the welcome page
    When I go to the home page
    Then I should see "Hello, world!"
