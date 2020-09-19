$(function () {
  // 画像用のinputを生成する関数
  const buildFileField = (index) => {
      const html = `<label data-index="${index}" class="image-upload" id="image-upload-add">
                      <input type="file" class="js-file" multiple="multiple">
                      <p><i id="added" class="fas fa-camera"></i></p>
                    </label>`;
      return html;
  }
  const buildFileFieldDefault = (index) => {
    const html = `<label data-index="${index}" class="image-upload" id="image-upload-default">
                    <input type="file" class="js-file" multiple="multiple">
                    <p><i class="fas fa-camera"></i></p>
                    <p>ドラッグアンドドロップ<br>またはクリックしてファイルをアップロード</p>
                  </label>`;
    return html;
}

  const buildImg = (index, url) => {
    const html = `<div class="preview" data-index="${index}">
                    <img data-index="${index}" src="${url}" width="100px" height="100px">
                    <div data-index="${index}" class = "preview__change">
                      <label data-index="${index}" class="preview__change__upload">変更
                        <input type="file" class="js-file" style="visibility: hidden">
                      </label>
                      <div class="preview__change__delete">削除</div>
                    </div>
                  </div>`;
    return html;
  }

  // 画像を管理するための配列を定義する。
  var files_array = []

  
  //新規アップロード時の実行内容（files_arrayはajax取得とform選択で取り方が違う為、統一化しない）
  function new_upload(targetIndex, blobUrl) {
    //古い画像アップロードフォルダーを削除
    $('.image-upload').remove();
    // 新規画像追加の処理  
    $('.js-file_group').append(buildImg(targetIndex, blobUrl));
    targetIndex++;
    $('.js-file_group').append(buildFileField(targetIndex));
    var preview = $('.preview').length;
    if (preview >= 10){
       $("#image-upload-add").css("display", "none");
    }
   return targetIndex
  }

  // newアクション時には実行させないようにする必要あり
  $(function () {
    $.getJSON('edit')
      .done(function (datas) {
        var targetIndex = 0
        datas.forEach(function (data) {
          //最初の値は0にする（htmlでも最初は0,他の値の場合form送信時に空の配列ができるのでエラーになってしまう）
          var blobUrl = data.image
          //配列の該当箇所を"exist"書き換える（追加）
          files_array[targetIndex] = "exist"
          targetIndex = new_upload(targetIndex, blobUrl)
        })
      })
      .fail(function () {
        console.log("NG")
      })
  })

  //ドラックアンドドロップ
  $(document).on("dragenter dragover", function (e) {
    e.stopPropagation();
    e.preventDefault();
    this.style.background = "#ff3399";
  }, false);
  $(document).on("dragleave", function (e) {
    e.stopPropagation();
    e.preventDefault();
    this.style.background = "#ffffff";
  }, false);
  $(document).on("drop", function (e) {
    e.stopPropagation();
    e.preventDefault();
  });
  $("#image-box").on("drop", function (e) {
    var targetIndex = files_array.length
    e.preventDefault();
    const files = e.originalEvent.dataTransfer.files;
    for (var i = 0; i < files.length; i++) {
      var file = files[i];
      const blobUrl = window.URL.createObjectURL(file);
      //配列の該当箇所を書き換える（追加or上書き）
      files_array[targetIndex] = files[i]
      // 該当indexを持つimgタグがあれば取得して変数imgに入れる(画像変更の処理)
      if (img = $(`img[data-index="${targetIndex}"]`)[0]) {
        img.setAttribute('src', blobUrl);
      } else {
        //画像を新規アップロード&targetIndexを更新
        targetIndex = new_upload(targetIndex, blobUrl)
      }
    }
  });



  $('#image-box').on('change', '.js-file', function (e) {
    // ファイルのブラウザ上でのURLを取得する
    var targetIndex = $(this).parent().data('index');
    const files = e.target.files;
    for (var i = 0; i < files.length; i++) {
      var file = files[i];
      const blobUrl = window.URL.createObjectURL(file);
      //配列の該当箇所を書き換える（追加or上書き）
      files_array[targetIndex] = files[i]
      // 該当indexを持つimgタグがあれば取得して変数imgに入れる(画像変更の処理)
      if (img = $(`img[data-index="${targetIndex}"]`)[0]) {
        img.setAttribute('src', blobUrl);
      } else {
        var preview = $('.preview').length;
        if(preview <= 9){
          targetIndex = new_upload(targetIndex, blobUrl)
        }
      
      }
    }
  });

  

  //画像削除アクション
  $(document).on('click', '.preview__change__delete', function () {
        //クリック対象のindexを取得
        const targetIndex = $(this).parent().data('index');
        var preview = $('.preview').length;
        console.log(preview)
        if (preview == 10){
          $(`label[data-index="${targetIndex}"]`).remove();
          $(`div[data-index="${targetIndex}"]`).remove();
          files_array[targetIndex] = "";
          $("#image-upload-add").css("display", "block");
        }else if(preview == 1){
          $(`label[data-index="${targetIndex}"]`).remove();
          $(`div[data-index="${targetIndex}"]`).remove();
          files_array[targetIndex] = "";
          $('.js-file_group').append(buildFileFieldDefault(targetIndex));
          $('#image-upload-add').remove();
        }else{
          $(`label[data-index="${targetIndex}"]`).remove();
          $(`div[data-index="${targetIndex}"]`).remove();
          files_array[targetIndex] = "";
        }
        


  });


  //ページのform送信アクション
  $('.new_product, .edit_product').on('submit', function (e) {
    e.preventDefault();
    // 画像以外のform情報をformDataにthisで追加
    var formData = new FormData($(this).get(0));
    var url = $(this).attr('action')

    // 配列の中の空白を削除した綺麗な配列を新規に作成
    // files_tidy_array = $.grep(files_array, function (e) {
    //   return e !== "";
    // });
    files_array.forEach(function (file) {
      // top_back_images→{images→[]}という形で[]内にfileが配列で格納されるようなパラメータに指定
      formData.append("pictures[images][]", file)
    });

    if ($(this).attr('class') == "new_product") {
      $.ajax({
        url: url,
        type: "POST",
        data: formData,
        dataType: 'json',
        contentType: false,
        processData: false
      })
        .done(function (data) {
          alert('出品に成功しました！');
        })
        .fail(function (XMLHttpRequest, textStatus, errorThrown) {
          alert('出品に失敗しました！');
        })
        .always(function () {
          $(".submit").removeAttr("disabled")
        }) 
    } else if ($(this).attr('class') == "edit_item") {
      $.ajax({
        url: url,
        type: "PATCH",
        data: formData,
        dataType: 'json',
        contentType: false,
        processData: false
      })
        .done(function (data) {
          alert('出品に成功しました！');
        })
        .fail(function (XMLHttpRequest, textStatus, errorThrown) {
          alert('出品に失敗しました！！');
        })
        .always(function () {
          $(".submit").removeAttr("disabled")
        }) 
    }
  });
   // 手数料計算機能
  //  https://qiita.com/potterqaz/items/3572b219572ba2818725
   $(window).on('load input', function() { //リアルタイムで表示したいのでinputを使う｡ただ、edit時はすでに入力されているものの計算をして欲しいためloadも記述し、複数条件とする。
        var data = $('#product_price').val(); // val()でフォームのvalueを取得(数値)
        var profit = Math.round(data * 0.9)  // 手数料計算を行う｡dataにかけているのが0.9なのは単に引きたい手数料が10%のため｡
        var fee = (data - profit) // 入力した数値から計算結果(profit)を引く｡それが手数料となる｡
        $('.right_bar').html(fee) //  手数料の表示｡html()は追加ではなく､上書き｡入力値が変わる度に表示も変わるようにする｡
        $('.right_bar').prepend('¥') // 手数料の前に¥マークを付けたいので
        $('.right_bar_2').html(profit)
        $('.right_bar_2').prepend('¥')
        // $('#price').val(profit) // 計算結果を格納用フォームに追加｡もし､入力値を追加したいのなら､今回はdataを引数に持たせる｡
        if(profit == '') {   // もし､計算結果が''なら表示も消す｡
        $('.right_bar_2').html('');
        $('.right_bar').html('');
        }
  });

  $(function() {
    $('img.thumb').mouseover(function(){
      
      var selectedSrc = $(this).attr('src').replace(".thumb");
      
      // 画像入れ替え
      $('img.mainImage').stop().fadeOut(50,function(){
        $('img.mainImage').attr('src', selectedSrc);
        $('img.mainImage').stop().fadeIn(200);
      });
      // サムネイルの枠を変更
        //$(this).css({"border":"2px solid #ff5a71"});
    });
    
    // マウスアウトでサムネイル枠もとに戻す
    $('img.thumb').mouseout(function(){
      $(this).css({"border":""});
    });
  });
});