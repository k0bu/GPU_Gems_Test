using System.Collections.Generic;
using UnityEngine;

public class GrassPointRenderer : MonoBehaviour {

	//public Mesh grassMesh;
	//public Material material;

	public Mesh mesh;
	public MeshFilter filter;

	public int seed;
	public Vector2 size;
	[Range(1,99999)]
	public int grassNumber;

	public float startHeight = 1000;
	public float yOffset = 0.5f;
	List<Matrix4x4> matrices;

	public float uvScale = 1000;

	void Start() {
		Random.InitState(seed);
		//matrices = new List<Matrix4x4>(grassNumber);
		List<Vector3> positions = new List<Vector3>(grassNumber);
		int[] indices = new int[grassNumber];
		List<Color> colors = new List<Color>(grassNumber);
		List<Vector3> normals = new List<Vector3>(grassNumber);
		List<Vector2> uvs = new List<Vector2>(grassNumber);
		for(int i = 0; i < grassNumber; i++){
			Vector3 origin = transform.position;
			origin.y = startHeight;
			origin.x += size.x * Random.Range(-.5f, .5f);
			origin.z += size.y * Random.Range(-.5f, .5f);
			Ray ray = new Ray(origin, Vector3.down);
			RaycastHit hit;
			if(Physics.Raycast(ray, out hit)){
				origin = hit.point;
				origin.y += yOffset;
				//Quaternion rot = Quaternion.FromToRotation(Vector3.up, hit.normal);


				positions.Add(origin);
				indices[i] = i;
				colors.Add(new Color(Random.Range(.0f, 1.0f),Random.Range(.0f, 1.0f),Random.Range(.0f, 1.0f), 1));
				normals.Add(hit.normal);
				var uv = new Vector2(origin.x - this.transform.position.x, origin.z - this.transform.position.z) / uvScale;
				uvs.Add(uv);
				//matrices.Add(Matrix4x4.TRS(origin, rot, Vector3.one));
			}
		}
		mesh = new Mesh();
		mesh.SetVertices(positions);
		mesh.SetIndices(indices, MeshTopology.Points, 0);
		mesh.SetColors(colors);
		mesh.SetNormals(normals);
		mesh.SetUVs(0, uvs);
		filter.mesh = mesh;
		
	}

	void Update(){
		//Graphics.DrawMeshInstanced(grassMesh, 0, material, matrices);
	}
}
