cls
$my_courses = @("course1 # Learning Task Automations # Vijay            ", 
                             "course2 # Advanced Scripting & tool making #  Vijay          ", 
                              "course3 # AD Management using PowerShell /In progress # Vijay            

                          ")


# contains word "task" to file
foreach($element in $my_courses)
{
    if ($element -like "*task*")
    {
        $element >> c:\temp\task.txt
    }
}

#sort
$my_courses = $my_courses | Sort-Object 
$my_courses

#sort descending 
$my_courses = $my_courses | Sort-Object -descending
$my_courses



# contains word "task" to file
foreach($element in $my_courses)
{
    $s = $element.Split("#")
    $course = $s[1]
    $course = $course.ToUpper()
    $author = $s[2]
    Write-Output "Hi. you are invited to join me in $course whose author is $author"
}
 