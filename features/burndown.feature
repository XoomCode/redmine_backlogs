Feature: Scrum master
  As a scrum master
  I want to manage sprints and their stories
  So that they get done according the product owner's requirements

  Background:
    Given the ecookbook project has the backlogs plugin enabled
      And I am a scrum master of the project
      And I have the following issue statuses available:
        | name        | is_closed | is_default | default_done_ratio |
        | New         |         0 |          1 |                    |
        | Assigned    |         0 |          0 |                    |
        | In Progress |         0 |          0 |                    |
        | Resolved    |         0 |          0 |                    |
        | Feedback    |         0 |          0 |                    |
        | Closed      |         1 |          0 |                    |
        | Accepted    |         1 |          0 |                    |
        | Rejected    |         1 |          0 |                  1 |
      And the project has the following sprint:
        | name       | sprint_start_date | effective_date  |
        | Sprint 001 | today             | 1.week.from_now |
      And the project has the following stories in the product backlog:
        | position | subject | 
        | 1        | Story 1 |
        | 2        | Story 2 |
        | 3        | Story 3 |
        | 4        | Story 4 |
      And the project has the following stories in the following sprints:
        | position | subject | sprint     | points | offset |
        | 1        | Story A | Sprint 001 | 1      | 0d     |
        | 2        | Story B | Sprint 001 | 2      | 0d     |
        | 3        | Story C | Sprint 001 | 4      | 0d     |
      And the project has the following tasks:
        | subject      | story     | hours_remaining | status | offset |
        | A.1          | Story A   | 10              | New    | 1h     |
        | B.1          | Story B   | 20              | New    | 1h     |
        | C.1          | Story C   | 40              | New    | 1h     |

  Scenario: Tasks closed AFTER remaining hours is set to 0 
    Given I am viewing the taskboard for Sprint 001
      And I have made the following task mutations:
        | day     | task | hours_remaining | status      |
        | 1       | A.1  | 5               | In progress |
        | 1       | B.1  | 10              | In progress |
        | 2       | A.1  | 0               |             |
        | 2       | A.1  |                 | Closed      |
        | 2       | C.1  | 30              | In progress |
        | 3       | B.1  | 0               |             |
        | 3       | B.1  |                 | Closed      |
        | 3       | C.1  | 25              |             |
        | 4       | C.1  | 10              |             |
        | 5       | C.1  | 0               |             |
        | 5       | C.1  |                 | Closed      |
      Then the sprint burndown should be:
        | day     | committed_points | points_to_resolve | hours_remaining |
        | start   | 7                | 7                 | 70              |
        | 1       | 7                | 7                 | 55              |
        | 2       | 7                | 6                 | 40              |
        | 3       | 7                | 4                 | 25              |
        | 4       | 7                | 4                 | 10              |
        | 5       | 7                | 0                 | 0               |

  Scenario: Tasks closed BEFORE remaining hours is set to 0
    Given I am viewing the taskboard for Sprint 001
      And I have made the following task mutations:
        | day     | task | hours_remaining | status      |
        | 1       | A.1  | 5               | In progress |
        | 1       | B.1  | 10              | In progress |
        | 2       | A.1  |                 | Closed      |
        | 2       | A.1  | 0               |             |
        | 2       | C.1  | 30              | In progress |
        | 3       | B.1  |                 | Closed      |
        | 3       | B.1  | 0               |             |
        | 3       | C.1  | 25              |             |
        | 4       | C.1  | 10              |             |
        | 5       | C.1  |                 | Closed      |
        | 5       | C.1  | 0               |             |
      Then the sprint burndown should be:
        | day     | committed_points | points_to_resolve | hours_remaining |
        | start   | 7                | 7                 | 70              |
        | 1       | 7                | 7                 | 55              |
        | 2       | 7                | 6                 | 40              |
        | 3       | 7                | 4                 | 25              |
        | 4       | 7                | 4                 | 10              |
        | 5       | 7                | 0                 | 0               |

  Scenario: New task and story added during sprint
    Given I am viewing the taskboard for Sprint 001
      And I have made the following task mutations:
        | day     | task | hours_remaining | status      |
        | 1       | A.1  | 5               | In progress |
        | 1       | B.1  | 10              | In progress |
        | 2       | A.1  | 0               |             |
        | 2       | A.1  |                 | Closed      |
        | 2       | C.1  | 30              | In progress |

      And the project has the following stories in the following sprints:
        | subject | sprint     | points | offset |
        | story d | Sprint 001 | 1      | 3d     |

      And the project has the following tasks:
        | subject      | story     | hours_remaining | status | offset |
        | D.1          | story d   | 40              | New    | 1h     |

      And I have made the following task mutations:
        | day     | task | hours_remaining | status      |
        | 3       | B.1  | 0               |             |
        | 3       | B.1  |                 | Closed      |
        | 3       | C.1  | 25              |             |
        | 4       | C.1  | 10              |             |
        | 4       | D.1  | 20              | In Progress |
        | 5       | C.1  | 0               |             |
        | 5       | C.1  |                 | Closed      |
        | 5       | D.1  | 0               |             |
        | 5       | D.1  |                 | Closed      |

      Then the sprint burndown should be:
        | day     | committed_points | points_to_resolve | hours_remaining |
        | start   | 7                | 7                 | 70              |
        | 1       | 7                | 7                 | 55              |
        | 2       | 7                | 6                 | 40              |
        | 3       | 11               | 8                 | 65              |
        | 4       | 11               | 4                 | 30              |
        | 5       | 11               | 0                 | 0               |
