/*global waitsFor:true expect:true describe:true beforeEach:true it:true spyOn:true */

describe("User Integration", function() {

  beforeEach(function() {
    $('<div id="main"><div class="rootElement"></div></div>').appendTo($('body')).hide();
    Ember.run(Discourse, Discourse.advanceReadiness);
  });

  afterEach(function() {
    Discourse.reset();
  });

  describe("emailValid", function() {

    it("allows upper case in first part of emails", function() {
      visit("/").then(function() {
        expect(exists("#main")).toBe(true);
      });
    });

  });

});