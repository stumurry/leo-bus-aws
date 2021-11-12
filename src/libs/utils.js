'use strict'

const changeCase = require('change-case')
const moment = require('moment')

module.exports = {
  // https://coderwall.com/p/iprsng/convert-snake-case-to-camelcase
  snakeToCamel: snakeWord => {
    const find = /_\w/g
    const convert = matches => matches[1].toUpperCase()

    return snakeWord.replace(find, convert)
  },
  removeHyphen: hyphenedWord => hyphenedWord.replace(/-/g, ''),
  camelToSnake,
  formatDate,
  formatDateToUTC,
  groupBy,
  objectCamelToSnake: objIn => Object.entries(objIn).reduce((objOut, value) => {
    objOut[camelToSnake(value[0])] = value[1]
    return objOut
  }, {}),
  rand: (min, max) => {
    return (Math.random() * (max - min)) + min
  },
  timeout: (ms) => {
    return new Promise(resolve => setTimeout(resolve, ms))
  }
}

/**
 * See https://stackoverflow.com/questions/14446511/most-efficient-method-to-groupby-on-an-array-of-objects
 */
function groupBy (xs, key) {
  return xs.reduce(function (rv, x) {
    (rv[x[key]] = rv[x[key]] || []).push(x)
    return rv
  }, {})
}

// Transform special camel case to snake case. If you can do it shorter, go for it
// Ex: LifetimeDealershipTypeID to dealership_id_dealership_id or GVWithMVR to gv_with_mvr
function camelToSnake (camelCaseWord) {
  return changeCase.snake(camelCaseWord)
}

function formatDate (date, formatIn = 'MM/DD/YYYY hh:mm:ss A', formatOut = 'YYYY-MM-DD HH:mm:ss') {
  if (moment(date, formatIn).isValid()) {
    // Use the provided format
    date = moment(date, formatIn).format(formatOut)
  } else if (moment(date).isValid()) {
    // moment will validate any known ISO-8601 or RFC-2822 date format by default. Let it do it's magic.
    date = moment(date).format(formatOut)
  }
  return date
}

/**
 * @author w brito
 * @date 07/14/2019
 * @Convert dates to UTC and format it to specified/default format
 *  If date is already in UTC/Z just format it out
 **/
function formatDateToUTC (inputDate, zone, formatOut = 'YYYY-MM-DD HH:mm:ss', formatIn = null) {
  if (!inputDate) return inputDate
  try {
    inputDate = inputDate.toString()
  } catch (e) {
    throw new Error(`${e} Please, provide a valid date type ex: String, Date, moment()`)
  }

  const zUTCTime = inputDate.endsWith('z') ||
    inputDate.endsWith('Z') ||
    inputDate.toLowerCase().includes('utc') ||
    zone.toLowerCase() === 'z' ||
    zone.toLowerCase() === 'utc'

  const transformToUTC = (innerDate, retry = 1) => {
    const outDate = zUTCTime ? new Date(innerDate) : new Date(`${innerDate} ${zone}`)
    if (moment(outDate, formatOut).isValid()) {
      return moment(outDate).format(formatOut)
    } else {
      // if an invalid date, retry
      // but try formating with momentjs first before outputting in the input date
      if (retry > 0) {
        const retryDate = formatDate(innerDate)
        return transformToUTC(retryDate, --retry)
      }
      return inputDate
    }
  }
  return transformToUTC(inputDate)
}
