export default function(){
  $(document).on('click', '.add-card-to-deck-btn', function(e) { addCard(e); });

  function addCard(e) {
    var $addButton = $(e.target);
    var $cardId = $('.card-select option:selected').val()
    var csrf_token = $('input[name="csrf_token"]').val();
    var $userId = $(location).attr('pathname').split('/')[1];
    var $deckId = $(location).attr('pathname').split('/')[3];
    var params = {"card_deck_params": {"card_id": $cardId, "deck_id": $deckId, "user_id": $userId}};

    $.ajax({
      url: '/'+ $userId + '/add-card-to-deck',
      type: 'POST',
      beforeSend: function(xhr) {
        xhr.setRequestHeader('x-csrf-token', csrf_token)
      },
      data: params,
      success: function(response) {
        updateCards($userId, response.cards)
      }
    });
  }

  function updateCards(userId, cards) {
    var newCards = _.map(cards, function(card) {
      var cardPath = getShowCardPath(userId, card.id)
      return '<a href="'+ cardPath +'">' +
      '<img src="' + card.small_image_uri +'" class="image-index-image">'

    }).join();
    $('.deck-cards-container').html(newCards);
  }

  function getShowCardPath(user_id, card_id) {
    var hostname = location.protocol+'//'+location.hostname+(location.port ? ':'+location.port: '');
    hostname + '/' + user_id + '/cards/' + card_id
  }
}
