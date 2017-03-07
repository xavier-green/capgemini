const Stat = require('./../stat/stat.model');
const moment = require('moment');

function list(req, res, next) {
    return Stat.findAsync()
    .then((stats) => {
    	var toSend = []
    	stats.map((day) => {
    		let obj = {
    			date: day.createdAt,
    			failedLogins: day.AuthNumber.failed,
    			successLogins: day.AuthNumber.succeeded,
    			hacks: day.succeededHacks,
    			hacksPrevented: day.attemptedHacks
    		}
    		toSend.push(obj)
    	})
    	return toSend;
    })
}

module.exports = exports = { list };
