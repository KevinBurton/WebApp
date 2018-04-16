using System.Linq;
using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using webapp.Controllers;

namespace tests
{
    [TestClass]
    public class UnitTest
    {
        [TestMethod]
        public void TestHomeControllerType()
        {
	          var controller = new HomeController();
            Assert.IsInstanceOfType(controller.Index(), typeof(IActionResult));
            Assert.IsInstanceOfType(controller.Error(), typeof(IActionResult));
            Assert.IsInstanceOfType(controller, typeof(Controller));
        }
        [TestMethod]
        public void TestHomeControllerModelState()
        {
	          var controller = new HomeController();
            var result = controller.Index();
            Assert.IsTrue(controller.ModelState.IsValid);
        }
        [TestMethod]
        public void TestSampleDataControllerType()
        {
	          var controller = new SampleDataController();
            Assert.IsInstanceOfType(controller, typeof(Controller));
        }
        [TestMethod]
        public void TestSampleDataControllerData()
        {
	          var controller = new SampleDataController();
            Assert.IsInstanceOfType(controller, typeof(Controller));
            Assert.IsTrue(controller.WeatherForecasts().Count() > 0);
        }
    }
}
