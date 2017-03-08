const Stat = require('./../stat/stat.model');
const User = require('./../user/user.model');
const moment = require('moment');

function list(req, res, next) {
    return User.findAsync()
    .then((users)=>{
        let usersCount = users.length
        return Stat.findAsync()
        .then((stats) => {
            var allStats = []
            var totalHacks = 0
            var totalHackAttempts = 0
            var totalSuccesses = 0
            var totalFails = 0
            var enrolmentAttempts = 0
            var loginAttempts = 0
            stats.map((day) => {
                totalHacks += parseInt(day.succeededHacks)
                totalHackAttempts += parseInt(day.attemptedHacks)
                totalSuccesses += parseInt(day.AuthNumber.succeeded)
                totalFails += parseInt(day.AuthNumber.failed)
                enrolmentAttempts += parseInt(day.enrolmentAttempts)
                loginAttempts += parseInt(day.loginAttempts)
                let obj = {
                    date: day.createdAt,
                    failedLogins: day.AuthNumber.failed,
                    successLogins: day.AuthNumber.succeeded,
                    hacks: day.succeededHacks,
                    hacksPrevented: day.attemptedHacks
                }
                allStats.push(obj)
            })
            let percentages = {
                hacks: Math.round(totalHacks/(totalHacks+totalHackAttempts)*10000)/100,
                hackAttempts: Math.round(totalHackAttempts/(totalHacks+totalHackAttempts)*10000)/100,
                success: Math.round(totalSuccesses/(totalSuccesses+totalFails)*10000)/100,
                fails: Math.round(totalFails/(totalSuccesses+totalFails)*10000)/100,
                enrollSamples: Math.round(enrolmentAttempts/(usersCount*3)*10000)/100,
                loginSampples: Math.round(loginAttempts/(totalSuccesses)*10000)/100
            }
            let toSend = {
                stats: allStats,
                percentages
            }
            return toSend;
        })
    })
}

module.exports = exports = { list };
