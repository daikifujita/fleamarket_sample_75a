$(function () {
  // 画像用のinputを生成する関数
  const buildFileField = (index) => {
    const html = `<label data-index="${index}" class="image-upload">
                    <input type="file" class="js-file" multiple="multiple" style="visibility: hidden">
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
    //新しい画像アップロードフォルダーを作成し、次に備える。
    targetIndex++;
    $('.js-file_group').append(buildFileField(targetIndex));
    // targetIndexを返さないと、手動の複数アップロードは上書きされてしまう。
    return targetIndex
  }

  //newアクション時には実行させないようにする必要あり
  // $(function () {
  //   $.getJSON('edit')
  //     .done(function (datas) {
  //       var targetIndex = 0
  //       datas.forEach(function (data) {
  //         //最初の値は0にする（htmlでも最初は0,他の値の場合form送信時に空の配列ができるのでエラーになってしまう）
  //         let blobUrl = data.image
  //         //配列の該当箇所を"exist"書き換える（追加）
  //         files_array[targetIndex] = "exist"
  //         //画像を新規アップロード&targetIndexを更新
  //         targetIndex = new_upload(targetIndex, blobUrl)
  //       })
  //     })
  //     .fail(function () {
  //       console.log("NG")
  //     })
  // })

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
        //画像を新規アップロード&targetIndexを更新
        targetIndex = new_upload(targetIndex, blobUrl)
      }
    }
  });

  //画像削除アクション
  $(document).on('click', '.preview__change__delete', function () {
    //クリック対象のindexを取得
    const targetIndex = $(this).parent().data('index');
    // 該当のindexのlabel(画像form)を削除
    $(`label[data-index="${targetIndex}"]`).remove();
    // 該当のindexのdiv(画像)を削除
    $(`div[data-index="${targetIndex}"]`).remove();
    // 該当のindexの画像をform送信対象から削除したいが、targetIndexがずれてしまうので一旦、対象を空白に変更。
    files_array[targetIndex] = "";
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
        });
    }
  });
});