class IntervalAlarmsManager
  ->
    @jobs = {}

    chrome.alarms.on-alarm.add-listener ({ name }) ~>
      @jobs[name]!

  add-job: (name, job) ->
    @jobs["#{name}"] = job

  remove-job: (name) ->
    delete @jobs["#{name}"]

  add: (name, period-in-minutes, job) ->
    @add-job "#{name}", job
    chrome.alarms.create "#{name}", { period-in-minutes }

  remove: (name, callback) ->
    chrome.alarms.clear "#{name}", (was-cleared) ->
      if was-cleared
        @remove-job "#{name}"

      callback? was-cleared

  update: (name, period-in-minutes) ->
    chrome.alarms.clear "#{name}", (was-cleared) ->
      if was-cleared
        chrome.alarms.create "#{name}", { period-in-minutes }
      else
        throw new Error "chrome.alrams.clear cannot work! task.id is #{task.id}"

module.exports = IntervalAlarmsManager
