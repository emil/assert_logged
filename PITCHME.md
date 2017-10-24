---

*assert_logged*

http://github.com/emil/assert_logged
---
Purpose
Integrated Log testing within Unit/Functional/Integration tests.
---
Small code (one class)
Follows the familiar assertion of *assert_select, assert_difference do ... end* 
---
General idea
Ensure the enclosed block emits (or not) the matching log.

``` ruby
 assert_logged(/Password was successfully changed/) do
   ... # test code
 end
```
(or assert_not_logged...)

---
``` ruby
def create
    @bug = Bug.new(bug_params)

    respond_to do |format|
      if @bug.save
        msg = 'Bug was successfully created.'
        logger.info msg
        format.html { redirect_to @bug, notice: msg }
        format.json { render :show, status: :created, location: @bug }
      else
        format.html { render :new }
        format.json { render json: @bug.errors, status: :unprocessable_entity }
      end
    end
  end
```
---

``` ruby

  test "should create bug" do
  
    assert_difference('Bug.count') do
      
      assert_logged(/Bug was successfully created/, Log4r::INFO) do
      
        post bugs_url, params: { bug: { description: @bug.description, status: @bug.status, title: @bug.title } }
      
      end
    
    end

    assert_redirected_to bug_url(Bug.last)
  end
```

---
Filter Sensitive Data (Credentials, Credit Cards etc)
---

Thank you
(http://github.com/emil/assert_logged)
Emil Marcetta
