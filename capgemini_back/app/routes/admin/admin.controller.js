const Stat = require('./../stat/stat.model');
const moment = require('moment');

function list(req, res, next) {
    return Stat.findAsync()
    .then((stats) => {
    	var allStats = []
    	var totalHacks = 0
    	var totalHackAttempts = 0
    	var totalSuccesses = 0
    	var totalFails = 0
    	stats.map((day) => {
    		totalHacks += parseInt(day.succeededHacks)
    		totalHackAttempts += parseInt(day.attemptedHacks)
    		totalSuccesses += parseInt(day.AuthNumber.succeeded)
    		totalFails += parseInt(day.AuthNumber.failed)
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
    		hacks: totalHacks/(totalHacks+totalHackAttempts)*100,
    		hackAttempts: totalHackAttempts/(totalHacks+totalHackAttempts)*100,
    		success: totalSuccesses/(totalSuccesses+totalFails)*100,
    		fails: totalFails/(totalSuccesses+totalFails)*100,
    	}
    	let toSend = {
    		stats: allStats,
    		percentages
    	}
    	return toSend;
    })
}

module.exports = exports = { list };
