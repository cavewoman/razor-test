export default function(){
  $(document).on('click', '.add-generic-card-btn', function(e) { addCardToUser(e); });

  function addCardToUser(e) {
    var $addButton = $(e.target);
    var csrf_token = $('input[name="csrf_token"]').val();
    var card_name = $('input[name="card_name"]').val();
    var user_id = $('input[name="user_id"]').val();
    var scryfall_uri = $('input[name="scryfall_uri"]').val();

    var params = {"card": {"name": card_name}, "json_return": true}

    $.ajax({
      url: '/'+ user_id + '/cards',
      type: 'POST',
      beforeSend: function(xhr) {
        xhr.setRequestHeader('x-csrf-token', csrf_token)
      },
      data: params,
      success: function(response) {
        location.href = getDomain() + response.redirect_url
        console.log(response)
      }
    });
  }

  function getDomain() {
    return location.protocol+'//'+location.hostname+(location.port ? ':'+location.port: '');
  }
}
