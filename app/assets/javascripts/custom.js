$( document ).ready(function() {
  $('#micropost_picture').bind('change', function() {
    var size_in_megabytes = this.files[0].size/1024/1024;
    if (size_in_megabytes > 1.5) {
      alert(I18n.t('alert_picture_size'));
    }
  });
});
