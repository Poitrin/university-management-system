$(document).ready(function () {
    window.select = function (type, id) {
        $('#internship_' + type + '_id').val(id);
        $('#' + type + 's').html($('#' + type + '-' + id).parent().html());
        $('#' + type + '-search-form').hide();
        $('#' + type + '-search-input').val("");
        $('.select-button').hide();
        $('.delete-button').show();
    };

    window.remove = function (type) {
        $('#internship_' + type + '_id').val("");
        $('#' + type + 's').html("");
        $('#' + type + '-search-form').show();
    }
});