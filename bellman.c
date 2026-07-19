struct Edge { int u, v, weight, padding; }; 

// A simple 3-node, 3-edge graph
struct Edge edges[3] = { 
    {0, 1, 4, 0}, 
    {1, 2, -2, 0}, 
    {0, 2, 5, 0} 
};

int dist[3]; // We will check this array in GTKWave!

int main() {
    // 1. Initialize distances (9999 acts as infinity)
    for (int i = 0; i < 3; i++) {
        dist[i] = 9999;
    }
    dist[0] = 0; // Start node is 0

    // 2. Bellman-Ford (Relax edges V-1 times)
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 3; j++) {
            int u = edges[j].u;
            int v = edges[j].v;
            int weight = edges[j].weight;
            
            if (dist[u] + weight < dist[v]) {
                dist[v] = dist[u] + weight;
            }
        }
    }
    
    return 0; // Jumps back to the end_loop in boot.s
}