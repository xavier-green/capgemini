const Promise = require('bluebird');
const mongoose = require('mongoose');
const httpStatus = require('http-status');
const APIError = require('../../helpers/APIError');
const moment = require('moment');
/**
 * User Schema
 */

const StatSchema = new mongoose.Schema({
    AuthNumber: {
        succeeded: {type: Number, default:0},
        failed: {type: Number, default:0},
    },
    AccountsHacked: [{
      hacker: String,
      hackee: String,
    }],
    succeededHacks: {type: Number, default:0},
    attemptedHacks: {type: Number, default:0},
    createdAt: {
      type: String,
      default: moment().format("DD/MM/YYYY"),
      unique: true,
    },
});
/**
 * Add your
 * - pre-save hooks
 * - validations
 * - virtuals
 */
/**
 * Methods
 */
StatSchema.method({
});
/**
 * Statics
 */
StatSchema.statics = {
    /**
     * Get user
     * @param {ObjectId} id - The objectId of user.
     * @returns {Promise<User, APIError>}
     */
    get(id) {
        return this.findById(id)
            .execAsync().then((stat) => {
                if (stat) {
                    return stat;
                }
                const err = new APIError('No such user exists!', httpStatus.NOT_FOUND);
                return Promise.reject(err);
            });
    },
    /**
     * List users in descending order of 'createdAt' timestamp.
     * @param {number} skip - Number of users to be skipped.
     * @param {number} limit - Limit number of users to be returned.
     * @returns {Promise<User[]>}
     */
    list({ skip = 0, limit = 50 } = {}) {
        return this.find()
            .sort({ AuthNumber: -1 })
            .skip(skip)
            .limit(limit)
            .execAsync();
    },
};
/**
 * @typedef User
 */
module.exports = exports = mongoose.model('Stat', StatSchema);
