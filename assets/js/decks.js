export default function(){
  $(document).on('click', '.add-card-to-deck-btn', function(e) { addCard(e); });
  $(document).on('click', '.delete-icon', function(e) { deleteCard(e); });

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
      return '<div class="deck-card-container">' +
        '<a href="'+ cardPath +'" class="deck-card-image">' +
          '<img src="' + card.small_image_uri +'" class="image-index-image">' +
        '</a>' +
        '<img src="/images/delete-icon-red-24x24.png" class="delete-icon card-' + card.id +'"/>' +
      '</div>'

    }).join();
    $('.deck-cards-container').html(newCards);
  }

  function deleteCard(e) {
    var $deleteButton = $(e.target);
    var deleteClasses = $deleteButton.attr("class")
    var cardId = deleteClasses.match(/card\-\d+/g)[0].split("card-")[1];
    var deckId = $(location).attr('pathname').split('/')[3];
    var userId = $(location).attr('pathname').split('/')[1];
    var csrf_token = $('input[name="csrf_token"]').val();
    var params = {"card_id": cardId, "deck_id": deckId}

    $.ajax({
      url: '/'+ userId + '/delete-card-from-deck',
      type: 'POST',
      beforeSend: function(xhr) {
        xhr.setRequestHeader('x-csrf-token', csrf_token)
      },
      data: params,
      success: function(response) {
        updateCards(userId, response.cards)
        console.log(response)
      }
    });
  }

  function getShowCardPath(user_id, card_id) {
    var hostname = location.protocol+'//'+location.hostname+(location.port ? ':'+location.port: '');
    return hostname + '/' + user_id + '/cards/' + card_id
  }


}
