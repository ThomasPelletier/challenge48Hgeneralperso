<template>
	<div class="flex flex-col">
		<div class="w-full  h-full flex flex-col space-y-4 justify-center">
			<button class="rounded-xl mx-[40%] p-4 bg-[#ffc72c]" v-on:click="moveToPanier">Mon panier</button>
			<select class="mx-[40%] rounded-xl" v-model="marchandSelected">
				<option  v-for="marchand of marchands" v-bind:value="marchand" v-bind:key="marchand">
				{{ marchand.nom }}
				</option>
			</select>
			<button class="rounded-xl p-4 bg-[#ffc72c] mx-[40%]" v-on:click="changeCard">Choisir ce commercant</button>

			<div v-for="produit in produits" :key="produit">
				<ProduitComponent :produit="produit" :showAAP="true" @addToPanier="addToPanier"/>
			</div>		
		</div>
	</div>
</template>

<script>
import {ServiceMarchand} from "../../src/assets/js/services/ServiceMarchand.js";
import {ServiceProduit} from "../../src/assets/js/services/ServiceProduit.js";
import ProduitComponent from "./ProduitComponent";

export default {
  name: "ShopComponent",
  components: {ProduitComponent},
  data: () => ({
    marchands: [],
    marchandSelected: null,
    produits: [],
  }),
  methods: {
    changeCard() {
      ServiceProduit.getAllProduitByMarchand(this.marchandSelected).then(async (response) => {
        this.produits = response;
      })
    },
    addToPanier(produit) {
      this.$emit("addToCart", produit);
    },
    moveToPanier() {
      this.$emit("changePage", "cart");
    }
  },
  mounted() {
    ServiceMarchand.getAll().then(async (response) => {
      this.marchands = response;
    })
  }
}
</script>

<style scoped>

div{
  margin-top: 2em;
  justify-content: space-between;
}

</style>