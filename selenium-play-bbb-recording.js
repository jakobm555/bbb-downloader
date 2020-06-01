/*
 * Drives Selenium to record the replay
 * args :
 *  - URL
 *  - seconds to record
 *  - port to connect to
 */

/* Capture a recording playback with Selenium for a certain duration */
var myArgs = process.argv.slice(2);
/*console.log('myArgs: ', myArgs);*/

var webdriver = require('selenium-webdriver'),
    By = webdriver.By,
    until = webdriver.until;

var driver = new webdriver.Builder()
/*    .forBrowser('chrome') */
    .forBrowser('firefox')
    .usingServer('http://localhost:'+ myArgs[2] + '/wd/hub')
    .build();

/* load webpage given its URL */
driver.get(myArgs[0]);

/* wait a bit before maximizing the window full-screen */
driver.sleep(1000 * 3);
driver.manage().window().maximize();

/* Cannot put it in full-screen with F11 in marionette mode */
/*driver.sleep(1000 * 5);*/
/*driver.findElement(By.tagName("body")).sendKeys(webdriver.Key.F11);*/

/* Start playback */
driver.sleep(1000 * 4);
driver.findElement(By.className('acorn-play-button')).click();

/* Stop after the required number of seconds */
driver.sleep(1000 * myArgs[1]);

driver.quit();
