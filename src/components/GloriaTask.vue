<template>
  <div class="gloria-task">
    <ui-collapsible :hide-icon="true">

      <div slot="header">
        <div class="row middle-xs">

          <div class="col-xs">
            <p><span>{{ name }}</span>
            <div class="row between-xs">
              <p>{{ i18n('TriggerCount', triggerCount) }} {{ pluralize(triggerCount, i18n('NounsTime')) }}, {{ i18n('PushCount', pushCount) }} {{ i18n('NounsNotification') }}</p>
              <p v-if="pushDate">{{ i18n('PushDate', pushDateRelative) }}</p>
            </div>
          </div>

          <div>
            <ui-switch :value.sync="isEnable"></ui-switch>
          </div>

        </div>
      </div>

      <div class="row middle-xs">

        <div class="col-xs">
          <gloria-numberbox
            icon="event"
            name="triggerInterval"
            :label="i18n('TriggerInterval')"
            :min="1"
            :max="60 * 24"
            :value.sync="triggerInterval"
            :help-text="helpText"
          ></gloria-numberbox>
          <ui-checkbox v-el:need-interaction :model.sync="needInteraction">{{ 'InteractionRequired' | i18n }}</ui-checkbox>
          <p>{{ 'Source' | i18n }}: <a v-show="origin" :href="origin" target="_blank">{{ origin }}</a><span v-show="!origin">{{ 'Local' | i18n }}</span></p>
        </div>

        <div class="col-xs-3 end-xs">
          <ui-icon-button v-show="origin" @click="showRemoveOriginConfirm = true" icon="content_cut" type="flat" :tooltip="i18n('CutOffSource')"></ui-icon-button>
          <ui-icon-button @click="showEditDialog = true" icon="edit" type="flat" :tooltip="i18n('Edit')"></ui-icon-button>
          <ui-icon-button @click="showDeleteConfirm = true" icon="delete_forever" type="flat" :tooltip="i18n('Delete')"></ui-icon-button>
        </div>

      </div>
    </ui-collapsible>

    <ui-confirm
      :header="i18n('CutOffSource')"
      type="warning"
      :confirm-button-text="i18n('CutOff')"
      :deny-button-text="i18n('Cancel')"
      confirm-button-icon="content_cut"
      @confirmed="(removeOrigin(), showRemoveOriginConfirm = false)"
      @denied="showRemoveOriginConfirm = false"
      :show.sync="showRemoveOriginConfirm"
      close-on-confirm
    >
      {{ 'CutOffSourceConfirm' | i18n }}
    </ui-confirm>

    <ui-modal @opened="setEditDialog" @closed="setEditDialog" :show.sync="showEditDialog" :header="i18n('Editor')">
      <ui-textbox name="editableName" :value.sync="editableName" :label="i18n('TaskName')" type="text" :placeholder="i18n('InputTaskName')"></ui-textbox>
      <ui-textbox
        :label="i18n('TaskCode')"
        :multi-line="true"
        icon="code"
        name="editableCode"
        :value.sync="editableCode"
        :placeholder="i18n('PasteYourFantasticCodeHere')"
      ></ui-textbox>
      <div slot="footer">
        <ui-button @click="(updateTask(), showEditDialog = false)" color="primary">{{ 'Save' | i18n }}</ui-button>
        <ui-button @click="showEditDialog = false">{{ 'Cancel' | i18n }}</ui-button>
      </div>
    </ui-modal>

    <ui-confirm
      :header="i18n('DeleteTask')"
      type="danger"
      :confirm-button-text="i18n('Delete')"
      :deny-button-text="i18n('Cancel')"
      confirm-button-icon="delete_forever"
      @confirmed="(removeTask(), showDeleteConfirm = false)"
      @denied="showDeleteConfirm = false"
      :show.sync="showDeleteConfirm"
      close-on-confirm
    >
      {{ 'DeleteTaskConfirm' | i18n }}
    </ui-confirm>

  </div>
</template>

<script lang="livescript">
'use strict'

require! 'vue': Vue
require! '../store.ls': store
require! '../actions/creator.ls': creator
require! './GloriaNumberbox.vue': GloriaNumberbox

export
  name: 'gloria-task'
  data: ->
    show-delete-confirm: false
    show-remove-origin-confirm: false
    show-edit-dialog: false
    editable-name: ''
    editable-code: ''
  components: {
    GloriaNumberbox
  }
  computed:
    help-text: ->
      Vue.filter('i18n')('TaskIntervalDescription', @name, @triggerInterval) + ' ' + Vue.filter('i18n')(Vue.filter('pluralize')(@triggerCount, 'NounsMinute'))
    push-date-relative: ->
      Vue.filter('relativeDate') @push-date
  methods:
    set-edit-dialog: ->
      @$data.editable-code = @code
      @$data.editable-name = @name
    update-task: ->
      store.dispatch creator.update-task @id, { name: @$data.editable-name, code: @$data.editable-code }
    remove-task: ->
      store.dispatch creator.remove-task @id
      store.dispatch creator.clear-stage @id
    remove-origin: ->
      store.dispatch creator.remove-origin @id
  watch:
    trigger-interval: ->
      store.dispatch creator.set-trigger-interval @id, @trigger-interval
    need-interaction: ->
      store.dispatch creator.set-need-interaction @id, @need-interaction
    is-enable: ->
      store.dispatch creator.set-is-enable @id, @is-enable
  props:
    id:
      type: String
    code:
      type: String
    name:
      type: String
    source:
      type: String
    trigger-count:
      type: Number
    push-date:
      type: String
    push-count:
      type: Number
    trigger-interval:
      type: Number
    need-interaction:
      type: Boolean
    is-enable:
      type: Boolean
    origin:
      type: String
</script>

<style lang="stylus">
@import '~keen-ui/src/styles/md-colors'

.gloria-task
  background: $md-grey-300

  .ui-switch
    z-index: 1

  .ui-collapsible
    margin-bottom: inherit

  .ui-collapsible-header
    height: auto

  .ui-collapsible-header-content
    width: 100%

  .ui-collapsible-body
    border: inherit
    width: auto

  .between-xs
    margin: 0
</style>
