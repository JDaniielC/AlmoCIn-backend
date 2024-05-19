Feature: type of users
  - 0: normal user (client)
  - 1: admin user (staff)
  - 2: super admin user (manager)

  Scenario: normal user can't access admin page
    Given I am a normal
    When I access the admin page
    Then I should see an error message
    Then I should not see the admin page

  Scenario: admin user can access admin page
    Given I am an admin
    When I access the admin page
    Then I should see the admin page
  
  Scenario: admin user can access normal page
    Given I am an admin
    When I access the normal page
    Then I should see the normal page
    Then I should not see the admin page

  Scenario: normal user can access normal page
    Given I am a normal
    When I access the normal page
    Then I should see the normal page
    Then I should not see the admin page

  Scenario: super admin user can access admin page
    Given I am a super admin
    When I access the admin page
    Then I should see the admin page

  Scenario: super admin user can access normal page
    Given I am a super admin
    When I access the normal page
    Then I should see the normal page
    Then I should not see the admin page

  Scenario: super admin user can access super admin page
    Given I am a super admin
    When I access the super admin page
    Then I should see the super admin page