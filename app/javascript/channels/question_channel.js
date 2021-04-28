import consumer from "./consumer"

export default consumer.subscriptions.create("QuestionChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    //console.log('QuestionChannel connected')
  },

  disconnected() {    
    // Called when the subscription has been terminated by the server
    //console.log('QuestionChannel disconnected')
  },

  received(data) {
    $('.questions').append(data)
  }
});
