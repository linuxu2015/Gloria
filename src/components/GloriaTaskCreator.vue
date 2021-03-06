<template>
  <div class="gloria-task-creator">

    <gloria-fab type="mini" @click="showNewDialogCode = true" color="primary" icon="add"></gloria-fab>

    <ui-modal :show.sync="showNewDialogCode" :header="'PasteYourCode' | i18n" :backdrop-dismissible="false">
      <ui-textbox
        :label="'TaskCode' | i18n"
        :multi-line="true"
        icon="code"
        name="code"
        :value.sync="code"
        :placeholder="'PasteYourFantasticCodeHere' | i18n"
      ></ui-textbox>
      <div slot="footer">
        <ui-button @click="switchDialog('showNewDialogCode', 'showNewDialogName')" color="primary">{{ 'Next' | i18n }}</ui-button>
        <ui-button @click="showNewDialogCode = false">{{ 'Cancel' | i18n }}</ui-button>
      </div>
    </ui-modal>

    <ui-modal :show.sync="showNewDialogName" :header="'GiveItName' | i18n" :backdrop-dismissible="false">
      <ui-textbox name="name" :value.sync="name" :label="'TaskName' | i18n" type="text" :placeholder="'InputTaskName' | i18n"></ui-textbox>
      <div slot="footer">
        <ui-button @click="switchDialog('showNewDialogName', 'showNewDialogConfig')" color="primary">{{ 'Next' | i18n }}</ui-button>
        <ui-button @click="switchDialog('showNewDialogName', 'showNewDialogCode')">{{ 'Back' | i18n }}</ui-button>
      </div>
    </ui-modal>

    <ui-modal :show.sync="showNewDialogConfig" :header="'FinalConfiguration' | i18n" :backdrop-dismissible="false">
      <gloria-numberbox
        icon="event"
        name="triggerInterval"
        :label="'TriggerInterval' | i18n"
        :min="1"
        :max="60 * 24"
        :value.sync="triggerInterval"
        :help-text="helpText"
      ></gloria-numberbox>
      <ui-checkbox v-el:need-interaction :model.sync="needInteraction">{{ 'InteractionRequired' | i18n }}</ui-checkbox>
      <div slot="footer">
        <ui-button @click="(showNewDialogConfig = false, createTask())" color="primary">{{ 'Finish' | i18n }}</ui-button>
        <ui-button @click="switchDialog('showNewDialogConfig', 'showNewDialogName')">{{ 'Back' | i18n }}</ui-button>
      </div>
    </ui-modal>

    <ui-modal :show.sync="showErrorDialog" :header="'Error' | i18n">
      {{ error }}
    </ui-modal>

  </div>
</template>

<script lang="livescript">
'use strict'

require! 'vue': Vue
require! '../store.ls': store
require! '../actions/creator.ls': creator
require! './GloriaFab.vue': GloriaFab
require! './GloriaNumberbox.vue': GloriaNumberbox

export
  name: 'gloria-task-creator'
  components: {
    GloriaFab
    GloriaNumberbox
  }
  data: ->
    show-new-dialog-code: false
    show-new-dialog-name: false
    show-new-dialog-config: false
    show-error-dialog: false
    code: ''
    name: ''
    trigger-interval: 5m
    need-interaction: false
    error: ''
  computed:
    help-text: ->
      Vue.filter('i18n')('TaskIntervalDescription', @name, @trigger-interval) + ' ' + Vue.filter('i18n')(Vue.filter('pluralize')(@trigger-count, 'NounsMinute'))
  methods:
    switch-dialog: (current, next) ->
      @$data[current] = false
      @$data[next] = true
    create-task: ->
      if @$data.name and @$data.code
        store.dispatch creator.add-task {
          name: @$data.name
          code: @$data.code
          trigger-interval: @$data.trigger-interval ? 5m
          need-interaction: @$data.need-interaction ? false
        }
        @$data.code = ''
        @$data.name = ''
        @$data.trigger-interval = 5m
        @$data.need-interaction = false
      else
        @$data.error = chrome.i18n.get-message 'NameAndCodeRequired'
        @$data.show-error-dialog = true
</script>

<style lang="stylus">
.gloria-task-creator
  .ui-textbox-textarea
    min-height: 200px

  .gloria-fab
    z-index: 1
</style>
