using UnityEngine;

public class GrassGenerator : MonoBehaviour {

	private Mesh mesh;
	public MeshFilter filter;

	//UnityのRandomの初期化
	//public int seed;
	
	public Vector2 size;

	[Range(1,9999)]
	public int maxGrassNumber;

	void Start() {
		//seedを用いた初期化により欲しいRandomも再現できる
		//Random.InitState(seed);


		Vector3[] positions = new Vector3 [maxGrassNumber];
		int[] indices = new int[maxGrassNumber];
		Vector3[] normals = new Vector3[maxGrassNumber];
		for(int i = 0; i < maxGrassNumber; i++){
			//真ん中の点、原点を定点にしている
			Vector3 centre = new Vector3(0,0,0);
			//size.x * size.yのマッピングに草が生えるように
			centre.x += size.x * Random.Range(-.5f, .5f);
			centre.z += size.y * Random.Range(-.5f, .5f);

			//centreに草を生やす
			positions[i] = centre;
			indices[i] = i;
			//法線を取り合えずy軸の正方向に
			normals[i] = Vector3.up;
		}
		//Meshに適用していく段階
		mesh = new Mesh();
		mesh.vertices = positions;
		//Meshのtriangle配列を指定するかわりに
		//1つの頂点ずつだけセットするため（他の頂点と関与しない）
		mesh.SetIndices(indices, MeshTopology.Points, 0);
		mesh.normals = normals;
		//MeshFilterにも忘れなく適用
		//MeshRendererに渡してくれる人
		filter.mesh = mesh;
		
	}
}
