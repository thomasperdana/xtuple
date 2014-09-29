/*jshint indent:2, curly:true, eqeqeq:true, immed:true, latedef:true,
newcap:true, noarg:true, regexp:true, undef:true, strict:true, trailing:true,
white:true*/
/*global XV:true, XT:true, _:true, console:true, XM:true, Backbone:true, require:true, assert:true,
setTimeout:true, before:true, clearTimeout:true, exports:true, it:true, describe:true, beforeEach:true */

(function () {
  "use strict";

  var assert = require("chai").assert,
    _ = require("underscore");

  /**
    @class
    @alias Printer
  */
  var spec = {
    recordType: "XM.Printer",
    collectionType: "XM.PrinterCollection",
    /**
      @member -
      @memberof Printer.prototype
      @description The Printer collection is cached.
    */
    cacheName: "XM.printers",
    listKind: "XV.PrinterList",
    instanceOf: "XM.Document",
    /**
      @member -
      @memberof Printer.prototype
      @description Printers are lockable.
    */
    isLockable: true,
    /**
      @member -
      @memberof Printer.prototype
      @description The ID attribute is "name", which will not be automatically uppercased.
    */
    idAttribute: "name",
    enforceUpperKey: false,
    attributes: ["name", "description"],
    extensions: [],
    /**
      @member -
      @memberof Printer.prototype
      @description Printers can be read by anyone but can only be created, updated,
        or deleted by users with the "MaintainPrinters" privilege.
    */
    privileges: {
      createUpdateDelete: "MaintainPrinters",
      read: true
    },
    createHash: {
      name: "TestPrinter" + Math.random(),
      description: "TestPrinterDescription" + Math.random(),
    },
    updatableField: "description"
  };

  var additionalTests = function () {
    /**
      @member Settings
      @memberof Invoice
      @description There is a setting "Valid Credit Card Days"
      @default 7
    */
    describe("User Preference Workspace tests", function () {
      var workspace,
        // XXX: Avoid the need for this. To be replaced when Forms object created.
        printSettingArray = ['SalesOrder', 'Invoice', 'PurchaseOrder', 'Location', 'EnterReceipt',
          'Shipment'];
      it("User navigates to User Preference workspace", function () {
        XT.app.$.postbooks.$.navigator.openPreferencesWorkspace();
        workspace = XT.app.$.postbooks.getActive().$.workspace;
        assert.equal(workspace.kind, "XV.UserPreferenceWorkspace");
      });
      it("User Preference workspace contains the PrintPicker widget, set to default value " +
        "'Browser', for each of the print settings 'attributes'", function () {
        assert.include(workspace.$, printSettingArray);
        _.each(printSettingArray, function (val) {
          return assert.equal(workspace.$[val].value.id, "Browser");
        });
      });
    });
  };

  exports.additionalTests = additionalTests;
  exports.spec = spec;

}());
