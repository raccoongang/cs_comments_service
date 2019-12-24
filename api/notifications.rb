post "#{APIPREFIX}/notifications" do
  # get all notifications for a set of users and a range of dates
  # for example
  # http://localhost:4567/api/v1/notifications?api_key=PUT_YOUR_API_KEY_HERE
  # with POST params 
  # user_ids=1217716,196353
  # from=2013-03-18+13%3A52%3A47+-0400
  # to=2013-03-19+13%3A53%3A11+-0400
  # note this takes date format 8601 year-month-day-(hours:minutes:seconds difference from UTC
  notifications_by_date_range_and_user_ids(CGI.unescape(params[:from]).to_time, CGI.unescape(params[:to]).to_time,params[:user_ids].split(','))
end

post "#{APIPREFIX}/broad/notifications" do
  # get all notifications for a set of users with their courses and a range of dates
  # for example
  # http://localhost:4567/api/v1/broad/notifications?api_key=PUT_YOUR_API_KEY_HERE
  # with POST params
  # users_with_courses=1217716::course-v1%3AedX%2BDemoX%2BDemo_Course,course-v2%3AedX%2BDemoX%2BDemo_Course2:::196353::course-v1%3AedX%2BDemoX%2BDemo_Course
  # from=2013-03-18+13%3A52%3A47+-0400
  # to=2013-03-19+13%3A53%3A11+-0400
  # note this takes date format 8601 year-month-day-(hours:minutes:seconds difference from UTC
  broad_notifications_by_date_range_and_user_ids_with_courses(
    CGI.unescape(params[:from]).to_time,
    CGI.unescape(params[:to]).to_time,
    params[:users_with_courses].split(':::')
  )
end
