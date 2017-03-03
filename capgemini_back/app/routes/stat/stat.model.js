const Promise = require('bluebird');
const mongoose = require('mongoose');
const httpStatus = require('http-status');
const APIError = require('../../helpers/APIError');
/**
 * User Schema
 */
const StatSchema = new mongoose.Schema({
    AuthNumber: {
        number: {type: Number, default:0},
        succeeded: {type: Number, default:0},
        failed: {type: Number, default:0},
    },
    AccountsHacked: [{
      hacker: String,
      hackee: String,
    }],
    numberOfHacks: {type: Number, default:0},
    createdAt: {
      type: Date,
      default: Date.now,
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
