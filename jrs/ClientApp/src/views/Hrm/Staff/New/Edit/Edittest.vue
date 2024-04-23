<template>
    <div id="app" class="root" v-if="tabs && tabs.length > 0">
        <div class="header">
            <h4> {{ infoToShow.staff_first_name + " " + infoToShow.staff_last_name }}</h4>
            <h4> {{ infoToShow.staff_code }}</h4>
        </div>

        <div class="tabs">
            <button v-for="(tab, idx) in tabs"
                    :key="idx"
                    @click="currentTab = tab.id"
                    :class="{ active: currentTab == tab.id }">
                {{ tab.name }}
            </button>
        </div>
        <div class="content">
            <!--<my-tab :tab="tabs[currentTab]"
            :currentTab="currentTab"
            :backAction="backAction"
            :theData="theData"
            idName="guid_staff_id"
            :idValue="id" />
    <div>
        <b-table striped hover :items="items"></b-table>
    </div>-->
            <my-tab v-for="(tab, index) in filteredTabs"
                    :key="index" :tab="tab"
                    :currentTab="currentTab"
                    :backAction="backAction"
                    :theData="theData"
                    idName="guid_staff_id"
                    :idValue="id"
                    :items="tab.items">
                <!-- Include the dynamic grid component in each tab -->
                <my-grid v-if="showGrid && currentTab === tab.id" :gridData="gridData" @edit-row="handleEditRow" @edit-click="handleEditClick" @delete-click="handleDeleteClick" />
            </my-tab>



            <!--<my-tab v-for="(tab, index) in filteredTabs"
            :key="index"
            v-if="currentTab === tab.id"
            :tab="tab"
            :currentTab="currentTab"
            :backAction="backAction"
            :theData="theData"
            idName="guid_staff_id"
            :idValue="id"
            :items="tab.items">
        <my-grid v-if="showGrid && currentTab === tab.id" :gridData="gridData" @edit-row="handleEditRow" @edit-click="handleEditClick" @delete-click="handleDeleteClick" />
    </my-tab>-->
        </div>
        </div>
</template>

<script>
    import { mapActions, mapGetters } from "vuex";
    import Tab from "@/components/Inputs/Tabs/Tab.vue";

    export default {
        props: ["id", "info"],

        
        
        components: {
            "my-tab": Tab,
        },
        computed: {
            filteredTabs() {
                // Replace the following condition with your own logic for filtering tabs
                return this.tabs.filter(tab => tab.someProperty === 'someValue');
            },
        },
        created: function() {
      this.currentTab = 0;
      this.initComponent();
    },
        data() {
            return {
                tabs: [],
                currentTab: 0,
                infoToShow: {},
                theData: [],
                inputs: [],
                columns: [],
                confs: [],
            };
        },
        methods: {
            ...mapActions("apiHandler", {
                updateWizard: "updateWizard",
                getConfiguration: "getConfiguration",
            }),
            async getConfFromApi(name, body, post) {
                return new Promise(async (resolve, reject) => {
                    try {
                        const confData = await this.getConfiguration({ name, body, post });
                        resolve(confData);
                    } catch (error) {
                        console.error("Error fetching configuration data: ", error);
                        reject([]);
                    }
                });
            },
            //gfhdfht
            convertDateToString(theDate) {
                const date = new Date(theDate);
                const yyyy = date.getFullYear();
                const mm = String(date.getMonth() + 1).padStart(2, "0"); // Months are 0-11, so we add 1 to get 1-12
                const dd = String(date.getDate()).padStart(2, "0");
                const formattedDate = `${yyyy}-${mm}-${dd}`;

                return formattedDate;
            },
            backAction() {
                this.$router.replace({ name: "staff" });
            },
            async handleCountryGuidChange(newValue) {
                debugger
                const theStates = await this.getConfFromApi(
                    "State/basedOnCountry",
                    newValue.target.value,
                    true
                );

                const theStatesOptions = theStates.map((ele) => ({
                    id: ele.guid_state_id,
                    label: ele.state_name,
                }));
                this.inputs[2].find((ele) => ele.model == "guid_state_id").options =
                    theStatesOptions;
                this.inputs[2].find(
                    (ele) => ele.model == "guid_state_id"
                ).disabled = false;
            },
            async handleStateGuidChange(newValue) {
                const thecities = await this.getConfFromApi(
                    "City/basedOnState",
                    newValue.target.value,
                    true
                );
                const cityList = thecities.map((ele) => ({
                    id: ele.guid_city_id,
                    label: ele.city_name,
                }));
                this.inputs[2].find((ele) => ele.model == "guid_city_id").options =
                    cityList;
                this.inputs[2].find(
                    (ele) => ele.model == "guid_city_id"
                ).disabled = false;
            },
            async handleNeighborhoodGuidChange(newValue) {
                const thecities = await this.getConfFromApi(
                    "Neighborhood/basedOnCity",
                    newValue.target.value,
                    true
                );
                const cityList = thecities.map((ele) => ({
                    id: ele.guid_neighborhood_id,
                    label: ele.neighborhood_name,
                }));
                this.inputs[2].find((ele) => ele.model == "guid_neighborhood_id").options =
                    cityList;
                this.inputs[2].find(
                    (ele) => ele.model == "guid_neighborhood_id"
                ).disabled = false;
            },
            async initComponent() {

                let localThis = this;
                this.infoToShow = JSON.parse(this.info);

                const confs = [
                    {
                        id: 1,
                        routeName: "IndividualDocumentType",
                        idName: "guid_document_type_id",
                        labelName: "document_type",
                        extraName: "guid_country_id",
                    },
                    {
                        id: 2,
                        routeName: "Gender",
                        idName: "gender_id",
                        labelName: "gender",
                    },
                    {
                        id: 200,
                        routeName: "Language",
                        idName: "guid_language_id",
                        labelName: "language_name",
                    },

                    {
                        id: 7,
                        routeName: "HouseholdDocumentType",
                        idName: "guid_document_type_id",
                        labelName: "document_type",
                    },

                    {
                        id: 13,
                        routeName: "DataSection/Enterable",
                        idName: "guid_data_section_id",
                        labelName: "data_section",
                    },
                    {
                        id: 14,
                        routeName: "Common",
                        idName: "blood_type_id",
                        labelName: "blood_type",
                    },
                ];
                this.confs = confs;
                if (!this.id) {
                    this.$router.replace({ name: "NotFound" });
                }
                const newConfs = JSON.parse(JSON.stringify(localThis.confs));
                for (let i = 0; i < newConfs.length; i++) {
                    const conf = newConfs[i];
                    let requ = await localThis.getConfFromApi(conf.routeName);
                    const ar = [];

                    for (let j = 0; j < requ.length; j++) {
                        let dd = {};
                        dd.id = requ[j][conf.idName];
                        dd.label = requ[j][conf.labelName];
                        if (conf.extraName) {
                            dd[conf.extraName] = requ[j][conf.extraName];
                        }
                        ar.push(dd);
                    }
                    conf.data = ar;
                }
                localThis.confs = newConfs;

                const inputs = [
                    [
                        {
                            id: 0,
                            label: "guid_staff_country_id",
                            field: "guid_staff_country_id",
                            primary: true,
                            // hide: true,
                        },
                        {
                            id: 1,
                            label: "guid_staff_id",
                            field: "guid_staff_id",
                            //  hide: true,
                        },
                        {
                            id: 2,
                            model: "staff_first_name",
                            type: "text",
                            label: "HRM.STAFF.staff_first_name",
                            required: true,
                            widthPercentage: 40,
                            marginRightPercentage: 10,
                        },
                        {
                            id: 3,
                            model: "staff_first_name_native",
                            type: "text",
                            label: "HRM.STAFF.staff_first_name_native",
                            required: true,
                            widthPercentage: 40,
                            marginRightPercentage: 10,
                        },
                        {
                            id: 4,
                            model: "staff_last_name",
                            type: "text",
                            label: "HRM.STAFF.staff_last_name",
                            required: true,
                            widthPercentage: 40,
                            marginRightPercentage: 10,
                        },

                        {
                            id: 16,
                            model: "staff_is_active",
                            label: "HRM.STAFF.staff_is_active",
                            type: "radio",
                            required: false,
                            options: [
                                { id: "false", label: "No" },
                                { id: "true", label: "Yes" },
                            ],
                            widthPercentage: 40,
                            marginRightPercentage: 10,
                        },
                    ],
                    [
                        {
                            id: 0,
                            label: "guid_staff_id",
                            field: "guid_staff_id",
                            hide: true,
                        },
                        {
                            id: 1,
                            label: "guid_staff_nationality_id",
                            field: "guid_staff_nationality_id",
                            hide: true,
                        },

                        {
                            id: 4,
                            model: "nationality_is_active",
                            label: "HRM.STAFF.nationality_is_active",
                            type: "radio",
                            required: false,
                            options: [
                                { id: "false", label: "No" },
                                { id: "true", label: "Yes" },
                            ],
                            widthPercentage: 40,
                            marginRightPercentage: 10,
                        },
                    ],
                    [
                        {
                            id: 0,
                            label: "guid_staff_id",
                            field: "guid_staff_id",
                            hide: true,
                        },
                        {
                            id: 1,
                            label: "HRM.STAFF.guid_staff_address_id",
                            field: "guid_staff_address_id",
                            hide: true,
                        },


                        {
                            id: 7,
                            model: "address_is_active",
                            label: "HRM.STAFF.address_is_active",
                            type: "radio",
                            required: false,
                            options: [
                                { id: "false", label: "No" },
                                { id: "true", label: "Yes" },
                            ],
                            widthPercentage: 40,
                            marginRightPercentage: 10,
                        },
                    ],
                    [
                        {
                            id: 0,
                            label: "guid_staff_id",
                            field: "guid_staff_id",
                            hide: true,
                        },
                        {
                            id: 1,
                            model: "guid_contact_type_id",
                            label: "HRM.STAFF.guid_contact_type_id",
                            //field: "guid_contact_type_id",
                            type: "select",
                            required: true,
                            options: localThis.confs.find(
                                (ele) => ele.routeName == "EducationalLevel"
                            ).data,
                            widthPercentage: 40,
                            marginRightPercentage: 10,
                        },

                        {
                            id: 4,

                            model: "contact_is_active",
                            label: "HRM.STAFF.contact_is_active",
                            type: "radio",
                            required: false,
                            options: [
                                { id: "false", label: "No" },
                                { id: "true", label: "Yes" },
                            ],
                            widthPercentage: 40,
                            marginRightPercentage: 10,
                        },
                    ],
                    [
                        {
                            id: 0,
                            label: "guid_staff_id",
                            field: "guid_staff_id",
                            hide: true,
                        },
                        {
                            id: 1,
                            label: "guid_staff_datasection_id",
                            field: "guid_staff_datasection_id",
                            hide: true,
                        },

                        {
                            id: 5,
                            model: "objective_code",
                            type: "text",
                            label: "HRM.STAFF.objective_code",
                            required: true,
                            disabled: true,
                            readonly: true,
                            widthPercentage: 40,
                            marginRightPercentage: 10,
                        },
                    ],
                    [
                        {
                            id: 0,
                            label: "guid_staff_id",
                            field: "guid_staff_id",
                            hide: true,
                        },
                        {
                            id: 1,
                            label: "guid_staff_document_id",
                            field: "guid_staff_document_id",
                            hide: true,
                        },



                        //----document_file field
                        {
                            id: 8,
                            model: "document_is_active",
                            label: "HRM.STAFF.document_is_active",
                            type: "radio",
                            required: false,
                            options: [
                                { id: "false", label: "No" },
                                { id: "true", label: "Yes" },
                            ],
                            widthPercentage: 40,
                            marginRightPercentage: 10,
                        },
                    ],
                    [
                        {
                            id: 0,
                            label: "Guid",
                            field: "guid_staff_id",
                            hide: true,
                        },
                        {
                            id: 1,
                            label: "Guid",
                            field: "guid_staff_educational_level_id",
                            hide: true,
                        },
                        {
                            id: 2,
                            model: "guid_educational_level_id",
                            type: "select",
                            label: "HRM.STAFF.guid_educational_level_id",
                            required: true,
                            options: localThis.confs.find(
                                (ele) => ele.routeName == "EducationalLevel"
                            ).data,
                            widthPercentage: 40,
                            marginRightPercentage: 10,
                        },

                        {
                            id: 6,
                            model: "education_is_active",
                            label: "HRM.STAFF.education_is_active",
                            type: "radio",
                            required: false,
                            options: [
                                { id: "false", label: "No" },
                                { id: "true", label: "Yes" },
                            ],
                            widthPercentage: 40,
                            marginRightPercentage: 10,
                        },
                    ],
                    [
                        {
                            id: 1,
                            label: "Guid",
                            field: "guid_staff_id",
                            hide: true,
                        },
                        {
                            id: 1,
                            label: "Guid",
                            field: "guid_staff_marital_status_id",
                            hide: true,
                        },
                        {
                            id: 13,
                            model: "guid_marital_status_id",
                            type: "select",
                            label: "HRM.STAFF.guid_marital_status_id",
                            required: true,
                            options: localThis.confs.find(
                                (ele) => ele.routeName == "MaritalStatus"
                            ).data,
                            widthPercentage: 40,
                            marginRightPercentage: 10,
                        },
                        {
                            id: 12,
                            model: "marital_is_active",
                            label: "HRM.STAFF.marital_is_active",
                            type: "radio",
                            required: false,
                            options: [
                                { id: "false", label: "No" },
                                { id: "true", label: "Yes" },
                            ],
                            widthPercentage: 40,
                            marginRightPercentage: 10,
                        },
                    ],

                ];
                const columns = [[], [], [], [], []];
                const theData = [];
                for (let t = 0; t < inputs.length; t++) {
                    const tabInp = inputs[t];
                    const theDatTab = {};
                    for (let k = 0; k < tabInp.length; k++) {
                        theDatTab[tabInp[k].model] = "";
                    }
                    theData.push(theDatTab);
                }
                localThis.inputs = inputs;
                localThis.columns = columns;
                localThis.theData = theData;
                localThis.tabs = [
                    {
                        id: 0,
                        name: "Personal Information",
                        theData: theData[0],
                        inputs: inputs[0],
                        grid: false,
                        routeGet: "Staff/GetStaffByGuid",
                        bodyGet: { guid_staff_id: this.id },
                        submitRoute: "Staff/Staff_Update",
                        saveDisabled: true,
                    },
                    {
                        id: 1,
                        name: "Nationality",
                        theData: theData[1],
                        inputs: inputs[1],
                        grid: false,
                        routeGet: "Staff/GetStaffByGuid",
                        bodyGet: { guid_staff_id: this.id },
                        submitRoute: "Staff/StaffNationality_update",
                        saveDisabled: true,
                    },
                    {
                        id: 2,
                        name: "Address information",
                        theData: theData[2],
                        inputs: inputs[2],
                        grid: false,
                        routeGet: "Staff/GetStaffByGuid",
                        bodyGet: { guid_staff_id: this.id },
                        submitRoute: "Staff/Staff_Update",
                        saveDisabled: true,
                    },
                    {
                        id: 3,
                        name: "Contact Information ",
                        theData: theData[3],
                        inputs: inputs[3],
                        grid: false,
                        routeGet: "Staff/GetStaffByGuid",
                        bodyGet: { guid_staff_id: this.id },
                        submitRoute: "Staff/Staff_Update",
                        saveDisabled: true,
                    },
                    {
                        id: 4,
                        name: "Data Section",
                        theData: theData[4],
                        inputs: inputs[4],
                        grid: false,
                        routeGet: "Staff/GetStaffByGuid",
                        bodyGet: { guid_staff_id: this.id },
                        submitRoute: "Staff/Staff_Update",
                        saveDisabled: true,
                    },
                    {
                        id: 5,
                        name: "Staff Document",
                        theData: theData[5],
                        inputs: inputs[5],
                        grid: false,
                        routeGet: "Staff/GetStaffByGuid",
                        bodyGet: { guid_staff_id: this.id },
                        submitRoute: "Staff/Staff_Update",
                        saveDisabled: true,
                    },
                    {
                        id: 6,
                        name: "Educational Level",
                        theData: theData[6],
                        inputs: inputs[6],
                        grid: false,
                        routeGet: "Staff/GetStaffByGuid",
                        bodyGet: { guid_staff_id: this.id },
                        submitRoute: "Staff/Staff_Update",
                        saveDisabled: true,
                    },
                    {
                        id: 7,
                        name: "Marital Status",
                        theData: theData[7],
                        inputs: inputs[7],
                        grid: false,
                        routeGet: "Staff/GetStaffByGuid",
                        bodyGet: { guid_staff_id: this.id },
                        submitRoute: "Staff/Staff_Update",
                        saveDisabled: true,
                    },

                ];
                let objData = await this.getConfiguration({
                    name: "Staff/GetStaffByGuid",
                    body: this.id,
                    post: true,
                });
                let theObj = objData[0];
                theObj.date_of_birth = this.convertDateToString(theObj.date_of_birth);

                console.log("thedata: ", theObj);

                for (let i = 0; i < this.theData.length; i++) {
                    const ta = this.theData[i];
                    for (let [key, value] of Object.entries(ta)) {
                        this.theData[i][key] = theObj[key] ? theObj[key].toString() : "";
                    }
                }
                for (let t = 0; t < inputs.length; t++) {
                    const tabInp = inputs[t];
                    const theDatTab = {};
                    for (let k = 0; k < tabInp.length; k++) {
                        theDatTab[tabInp[k].model] = "";
                    }
                    theData.push(theDatTab);

                    // Fetch data for each tab
                    const tabData = await this.getConfiguration({
                        name: this.tabs[t].routeGet,
                        body: this.tabs[t].bodyGet,
                        post: true,
                    });

                    // Assign fetched data to the corresponding tab
                    this.tabs[t].items = tabData;
                    this.tabs[t].theData = theData[t];
                    this.tabs[t].inputs = inputs[t];
                    this.tabs[t].grid = true;
                }

            },
        },
       // async initComponent() {
       
        watch: {
            theData: {

                deep: true,
                handler(newValue, oldValue) {
                    let localDisabled = false;
                    const tabInputs = this.inputs[this.currentTab];
                    for (let i = 0; i < tabInputs.length; i++) {
                        const inp = tabInputs[i];
                        const newVal = newValue[this.currentTab][inp.model];
                        if (inp.required && (!newVal || newVal == "")) {
                            localDisabled = true;
                            break;
                        }
                    }
                    this.tabs[this.currentTab].saveDisabled = localDisabled;
                    console.log("newvalue: ", newValue);
                },
            },
        },
    };
</script>

<style scoped>
    @import "./Edit.scss";
</style>
