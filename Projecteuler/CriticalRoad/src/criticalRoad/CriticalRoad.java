/**
 * 
 */
package criticalRoad;
import java.util.*;

/**
 * @author mingda.cai
 *
 */
public class CriticalRoad {

	
	public List<Integer> getCriticalNodes(int[][] edges, int numNodes, int numEdges) {
		HashMap<Integer, HashSet<Integer>> nodeMap = new HashMap<>();
		boolean[] visited = new boolean[numNodes];
		List<Integer> result = new ArrayList<Integer>();
		
		/*Create map nodes and initialize the children with empty object*/
		for(int i=0;i<numNodes;i++) {
			nodeMap.put(i, new HashSet<Integer>());
		}
		
		/*Add children for every node*/
		for(int[] e: edges) {
			nodeMap.get(e[0]).add(e[1]);
			nodeMap.get(e[1]).add(e[0]);
		}
		
		/*Loop each node to see if it is a critical node*/
		for(int i=0;i<numNodes;i++) {
			/*Initialize all the visited record array to be all false*/
			for(int j=0;j<numNodes;j++) {
				visited[j] = false;
			}
			/*Mark the current node id to be visited(true)*/
			visited[i] = true;
			/*Find a unvisited node as root and do Depth-Fist-Search*/
			for(int j=0;j<numNodes;j++) {
				if(visited[j] == false) {
					dfs(nodeMap, visited, j);
					break;
				}
			}
			/*After search, if there is unvisited node, then it means the current node id represents a critical node*/
			for(int j=0;j<numNodes;j++) {
				if(visited[j]==false) {
					result.add(i);
					break;
				}
			}
			
		}
		
		return result;
	}
	private void dfs(HashMap<Integer, HashSet<Integer>> mapNodes, boolean[] visited, int root) {
		for(Integer i: mapNodes.get(root)) {
			if(visited[i] == false) {
				visited[i]=true;
				dfs(mapNodes, visited, i);
			}
		}
	}
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		CriticalRoad cR = new CriticalRoad();
		int numNodes = 7;
		int numEdges = 7;
		int[][] edges = {{0, 1}, {0, 2}, {1, 3}, {2, 3}, {2, 5}, {5, 6}, {3, 4}};
		System.out.println(cR.getCriticalNodes(edges, numNodes, numEdges));
	}

}
