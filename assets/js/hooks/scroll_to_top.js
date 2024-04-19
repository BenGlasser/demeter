const ScrollToTop = {
    mounted() {
      console.log("ScrollToTop mounted")
      this.el.addEventListener("click", e => {
        console.log("ScrollToTop clicked")
        var elem = document.getElementById("foodtruck-table")
        elem.scrollTo({top: 0, behavior: 'smooth'})
      })

      var foodtruckTable = document.getElementById("foodtruck-table")
      foodtruckTable.addEventListener("scroll", e => {
        console.log("ScrollToTop scrolled")
        if (foodtruckTable.scrollTop > 0) {
          this.el.style.display = "block"
        } else {
          this.el.style.display = "none"
        }
      })
    }
  }

export { ScrollToTop };