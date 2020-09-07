$(function () {
  $(".listsLeft__item--first").hover(function () {
    $("ul.category1").show();

    $(".parent__list").hover(function () {
      $(this).addClass('active');
      $('.active').children('ul.category2').show();

        $(".child__list").hover(function () {
          $(this).addClass('active');
          $('.active').children('ul.category3').show();
        }, function () {
          $(this).removeClass('active');
          $(this).children('ul.category3').hide();
        });
      
    }, function () {
      $(this).removeClass('active');
      $(this).children('ul.category2').hide();
    });
    
  }, function () {
    $("ul.category1").slideUp();
  });
})