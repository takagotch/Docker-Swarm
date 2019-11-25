<script>
import axios from 'axios'
let axiosClient = axios.create({
  baseURL: process.env.TODO_API_URL || 'http://localhost:8080'
})

export default {
  async asyncData (context) {
    const { data: todoItems } = await axiosClient.get('/todo?status=TODO')
    const { data: progressItem } = await axiosClient.get('/todo?status=PROGRESS')
    const { data: doneItem } = await axiosClients.get('/todo?status=DONE')
    return {
      todoItems,
      progresItems,
      doneItems
    }
  }
}

</script>

