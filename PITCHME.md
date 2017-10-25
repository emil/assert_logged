---

# *assert_logged*

http://github.com/emil/assert_logged
---
# Purpose
Integrated Log testing within Unit/Functional/Integration tests.
---
* Small code (one ruby module)
* Follows the familiar assertion design *assert_select, assert_difference do ... end* 
---
# General idea
- Assert the enclosed block emits the log.
- Start/End block *defines* the beg/end of the log lines to consider
- Run Regexp/String matches against the log section

``` ruby
  test "should create bug" do
  
  assert_difference('Bug.count') do

    assert_logged(/Bug was successfully created/) do
      post bugs_url ...
    end
  end
end
```
---
---
(or assert_not_logged...)
``` ruby
 assert_not_logged(/Bug was successfully changed/) do
   #... test code
 end
```
---
Example : Model *Bug* logs the CRUD after_* events...
``` ruby
class Bug < ApplicationRecord
  after_create do
    logger.info "Bug##{id} was successfully created."
  end

  after_update do
    logger.info "Bug##{id} was successfully updated."
  end
  
end
```
---

Test that verifies record *create* log emitted
``` ruby
  test "should create bug" do
    assert_difference('Bug.count') do
      
      assert_logged(/Bug#\d+ was successfully created/, Log4r::INFO) do
        post bugs_url, params: { bug: { description: @bug.description, status: @bug.status, title: @bug.title } }
      end
    end

    assert_redirected_to bug_url(Bug.last)
  end
```
---
Test that verifies **permit/deny** parameters log emitted
``` ruby
  test "should deny not permitted parameters" do
    assert_difference('Bug.count') do
      
      assert_logged([/Bug#\d+ was successfully created/,
                     'Unpermitted parameter: :bad_param']) do
        post bugs_url, params: { bug: { bad_param: 'value', description: @bug.description, status: @bug.status, title: @bug.title } }
      end
    end

    assert_redirected_to bug_url(Bug.last)
  end
  
```
---
---
Test failed example
``` shell

$ bin/rails test test/controllers/bugs_controller_test.rb

# Running:

.......F

Failure:
BugsControllerTest#test_should_update_bug [/Users/emil/tmp/vanruby/assert_logged/test/controllers/bugs_controller_test.rb:53]:
A log entry should have matched the regular expression (?-mix:Bug#\d+ was successfully updated) at the given level: INFO in file /Users/emil/tmp/vanruby/assert_logged/log/test_20171024.log}


bin/rails test test/controllers/bugs_controller_test.rb:51



Finished in 0.514606s, 15.5459 runs/s, 44.6944 assertions/s.
8 runs, 23 assertions, 1 failures, 0 errors, 0 skips
```
---

---

# Thank you
(http://github.com/emil/assert_logged)
Emil Marcetta
---
